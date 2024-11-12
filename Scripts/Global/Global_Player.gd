extends Node

var Player_node: Node = null

# Quest vars
var selected_quest: Quest = null
var objectives: Node = null
var quest_manager: Node = null
var quest_tracker: Node = null
var title: Node = null
var amount: Node = null

var coin_amount = 0 # Used for rewards

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
func check_quest_objectives(target_id: String, target_type: String, quantity: int = 1):
	# No selected quest
	if Global_Player.selected_quest == null:
		return
	
	# Update objectives
	var objective_updated = false
	for objective in Global_Player.selected_quest.objectives:
		if objective.target_id == target_id and objective.target_type == target_type and not objective.is_completed:
			print("Completing objective for quest: ", Global_Player.selected_quest.quest_name)
			Global_Player.selected_quest.complete_objective(objective.id, quantity)
			objective_updated = true
			break
	
	# Provide rewards
	if objective_updated:
		if Global_Player.selected_quest.is_completed():
			handle_quest_completion(selected_quest)
	
		# Update UI
		update_quest_tracker(selected_quest)

# Player rewards
func handle_quest_completion(quest: Quest):
	for reward in quest.rewards:
		if reward.reward_type == "coins":
			coin_amount += reward.reward_amount
			update_coins()
	update_quest_tracker(quest)
	quest_manager.update_quest(quest.quest_id, "completed")

# Update coin UI
func update_coins():
	amount.text = str(coin_amount)

# Update tracker UI (This sets the selected Quest node)
# hides if no quest has been selected or when a quest is complete
func update_quest_tracker(quest: Quest):
	# if we have an active quest, populate tracker
	if quest:
		quest_tracker.visible = true
		title.text = quest.quest_name

		for child in objectives.get_children():
			objectives.remove_child(child)

		for objective in quest.objectives:
			var label = Label.new()
			label.text = objective.description

			if objective.is_completed:
				label.add_theme_color_override("font_color", Color(0, 1, 0))
			else:
				label.add_theme_color_override("font_color", Color(1,0, 0))

			objectives.add_child(label)

	# no active quest, hide tracker
	else:
		quest_tracker.visible = false

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
