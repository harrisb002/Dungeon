extends Node

var Player_node: Node = null

# Quest vars
var selected_quest: Quest = null
var objectives: Node = null
var quest_manager: Node = null
var quest_tracker: Node = null
var title: Node = null
var amount: Node = null

var coin_amount = 100 # Used for rewards

#Inventory vars
var inventory_hotbar = null

# Holds the animation_prefix for the current character selected
var character = ""

# Sets the player reference for inventory interactions
func set_player_ref(player):
	Player_node = player

# Sets nodes related to quest management interactions
func set_quest_node_refs(quest_manager_node, quest_tracker_node, title_node, objectives_node, amount_node):
	quest_manager = quest_manager_node
	quest_tracker = quest_tracker_node
	title = title_node
	objectives = objectives_node
	amount = amount_node

# Sets the inventory hotbar to hide during interactions
func set_inventory_hotbar(hotbar):
	inventory_hotbar = hotbar

# Check & update the objectives for the currenlty selected quest
# Also handles the logic to update th quest upon completion
func check_quest_objectives(target_id: String, target_type: String, quantity: int = 1) -> bool:
	# No selected quest
	if selected_quest == null:
		return false
	
	# Update objectives
	var objective_updated = false
	for objective in selected_quest.objectives:
		if objective.target_type == "coins" and not objective.is_completed:
			# Check if the coin_amount meets the required target
			if coin_amount >= objective.required_quantity:
				print("Completing coin collection objective for quest: ", selected_quest.quest_name)
				# Deduct coins required for the quest
				coin_amount -= objective.required_quantity
				update_coins()
				objective.is_completed = true
				objective_updated = true
				break
				
		elif objective.target_id == target_id and objective.target_type == target_type and not objective.is_completed:
			print("Completing other objective for quest: ", selected_quest.quest_name)
			selected_quest.complete_objective(objective.id, quantity)
			objective_updated = true
			break
	# Provide rewards
	if objective_updated and selected_quest.is_completed():
		selected_quest.state = "completed" 
		handle_quest_completion(selected_quest)
		return true

	# Update UI
	if objective_updated:
		update_quest_tracker(selected_quest)
	
	return false

func add_coins(amount: int):
	coin_amount += amount
	update_coins()  # Update UI
	if selected_quest != null:
		check_quest_objectives("coins", "collection")  # Check if any coin-related objectives are completed

# Update coin UI
func update_coins():
	amount.text = str(coin_amount)

# Player rewards
func handle_quest_completion(quest: Quest):
	if quest.rewards_given:
		return 

	for reward in quest.rewards:
		if reward.reward_type == "coins":
			add_coins(reward.reward_amount)  # Use add_coins to update coins
			print("Coins rewarded: ", reward.reward_amount)  # Debug print
			update_coins()
		elif reward.reward_type == "item":
			# Find the item data in the quest_items list
			var item_data = null
			for item in Global_Inventory.quest_items:
				if item["id"] == reward.reward_item_id:
					item_data = item
					break
			if item_data != null:
				item_data["quantity"] = reward.reward_item_quantity
				Global_Inventory.recieve_quest_item(item_data)
				print("Reward item added to inventory: ", item_data["name"])
			else:
				print("Reward item not found for ID: ", reward.reward_item_id)

	quest.rewards_given = true  # Mark rewards as given
	update_quest_tracker(quest)
	quest_manager.update_quest(quest.quest_id, "completed")

# Update tracker UI (This sets the selected Quest node)
# hides if no quest has been selected or when a quest is complete
func update_quest_tracker(quest: Quest):
	# if we have an active quest, populate tracker
	if quest:
		print("Quest is being tracked")
		quest_tracker.visible = true
		title.text = quest.quest_name

		for child in objectives.get_children():
			objectives.remove_child(child)

		for objective in quest.objectives:
			var label = Label.new()
			label.text = objective.description

			if objective.is_completed:
				label.queue_free()
				quest_tracker.visible = false
			else:
				label.add_theme_color_override("font_color", Color(1,0, 0))

			objectives.add_child(label)

# Update tracker if quest is completed
func _on_quest_updated(quest_id: String):
	var quest = quest_manager.get_quest(quest_id)
	if quest == selected_quest:
		update_quest_tracker(quest)
	selected_quest = null

# Update tracker if objective is completed
func _on_objective_updated(quest_id: String, objective_id: String):
	if selected_quest and selected_quest.quest_id == quest_id:
		update_quest_tracker(selected_quest)
	selected_quest = null
