extends Node

# This is a globally autoload script allowing for global access
# This will be responsible for managing the player inventory

# Will be used update the inventory UI
signal inventory_updated

var tile_map: TileMapLayer = null

@onready var inventory_slot_scene = preload("res://Scenes/Inventory/Inventory_Slot.tscn")
@onready var inventory_item_scene = preload("res://Scenes/Inventory/Inventory_item.tscn")
var Inventory_Script = preload("res://Scripts/Inventory/Inventory_Item.gd").new()

var inventory = []
var hotbar_size = 5
var hotbar_inventory = []

# Items used to spawn within the area defined (Will update to use tile map later)
var spawnable_items = [
	{"id": "coin", "quantity": 1, "type": "Currency", "name": "Coin", "effect": "Purchase", "texture": preload("res://allart/InventoryItems/coin.png"), "scale": Vector2(2, 2)},
	{"id": "common_key", "quantity": 0, "type": "Common", "name": "Key", "effect": "Open Chest", "texture": preload("res://allart/InventoryItems/commonKey.png"), "scale": Vector2(2, 2)},
	{"id": "gold_key", "quantity": 0, "type": "Golden", "name": "Key", "effect": "Open Chest", "texture": preload("res://allart/InventoryItems/goldKey.png"), "scale": Vector2(2, 2)},
	{"id": "boss_key", "quantity": 0, "type": "Boss", "name": "Key", "effect": "Open Chest", "texture": preload("res://allart/InventoryItems/bossKey.png"), "scale": Vector2(2, 2)},
	{"id": "flash_ring", "quantity": 0, "type": "Attachment", "name": "Flash Ring", "effect": "Increase Speed", "duration": 20, "texture": preload("res://allart/InventoryItems/increaseSpeed.png"), "scale": Vector2(2, 2)},
	{"id": "shroom", "quantity": 0, "type": "Consumable", "name": "Shroom", "effect": "Increase Slots", "texture": preload("res://allart/InventoryItems/inventoryBoost.png"), "scale": Vector2(2, 2)},
	{"id": "arrow", "quantity": 0, "type": "Weapon", "name": "Arrow", "effect": "", "texture": preload("res://allart/InventoryItems/arrow.png"), "scale": Vector2(2, 2)},
	{"id": "fire_skin", "quantity": 0, "type": "Potion", "name": "Fire Skin", "effect": "Reduce fire damage", "texture": preload("res://allart/InventoryItems/fireResistance.png"), "scale": Vector2(2, 2)},
	{"id": "health_potion", "quantity": 0, "type": "Potion", "name": "Health Potion", "effect": "+20 Health", "texture": preload("res://allart/InventoryItems/healthPotion.png"), "scale": Vector2(2, 2)},
	{"id": "cloak", "quantity": 0, "type": "Potion", "name": "Cloak", "effect": "Invisible for 20 seconds", "texture": preload("res://allart/InventoryItems/invisibility.png"), "scale": Vector2(2, 2)},
	{"id": "magic_potion", "quantity": 0, "type": "Potion", "name": "Magic Potion", "effect": "Restore mana", "texture": preload("res://allart/InventoryItems/magicPotion.png"), "scale": Vector2(2, 2)},
	{"id": "shield_potion", "quantity": 0, "type": "Potion", "name": "Shield Potion", "effect": "+20 Shield", "texture": preload("res://allart/InventoryItems/shieldPotion.png"), "scale": Vector2(2, 2)},
	{"id": "stamina_potion", "quantity": 0, "type": "Potion", "name": "Stamina Potion", "effect": "Reduce stamina", "texture": preload("res://allart/InventoryItems/staminaPotion.png"), "scale": Vector2(2, 2)},
	{"id": "map", "quantity": 0, "type": "Guide", "name": "Dungeon Map", "effect": "Discovery", "texture": preload("res://allart/InventoryItems/map.png"), "scale": Vector2(2, 2)},
]

var quest_items = [
	{"id": "poison_potion", "quantity": 0, "type": "Potion", "name": "Poison Potion", "effect": "Poison enemy", "texture": preload("res://allart/InventoryItems/poison.png"), "scale": Vector2(2, 2)},
	{"id": "shroom", "quantity": 0, "type": "Consumable", "name": "Shroom", "effect": "Increase Slots", "texture": preload("res://allart/InventoryItems/inventoryBoost.png"), "scale": Vector2(2, 2)},
]

func _ready():
	inventory.resize(3)
	hotbar_inventory.resize(hotbar_size)

# Adds reward item from quest completion
func recieve_quest_item(item):
	for i in range(inventory.size()):
		# Stack the item if it already exists in inventory
		# Based on dict. found in inventory_item.gd, pickup_items
		if inventory[i] != null and inventory[i]["name"] == item["name"] and inventory[i]["type"] == item["type"]:
			inventory[i]["quantity"] += 1
			inventory_updated.emit()
			return true
		elif inventory[i] == null:
			item["quantity"] = 1  
			inventory[i] = item
			inventory_updated.emit()
			return true
	return false

# Adds item and returns true if successfull
func add_item(item, to_hotbar = false):
	## Bool for item used for Quest completion
	var item_used
	print("Item info: ", item)
	## Check if item is needed for an active quest
	if Global_Inventory.is_item_needed(item.id):
		print("Item info: ", item)
		## Update the objective with the type collection (if item was used then dont add it to inventory)
		item_used = Global_Player.check_quest_objectives(item.id, "collection")
	else: 
		print("Item is not needed for any active quest")
	
	## Dont add item if used for Quest
	if item_used:
		return 

	var added_to_hotbar = false
	# Add the item to hotbar
	if to_hotbar:
		added_to_hotbar = add_hotbar_item(item)
		inventory_updated.emit()

	# Add to inventory if not hotbar
	if not added_to_hotbar:
		for i in range(inventory.size()):
			# Stack the item if it already exists in inventory
			# Based on dict. found in inventory_item.gd, pickup_items
			if inventory[i] != null and inventory[i]["name"] == item["name"] and inventory[i]["type"] == item["type"]:
				inventory[i]["quantity"] += 1
				inventory_updated.emit()
				return true
			elif inventory[i] == null:
				item["quantity"] = 1  
				inventory[i] = item
				inventory_updated.emit()
				return true
		return false

# Check if item added is a quest item for the currently selected quest
func is_item_needed(item_id: String) -> bool:
	if Global_Player.selected_quest != null:
		for objective in Global_Player.selected_quest.objectives:
			## Checking if targetID for quest is the same as the itemID (REQUIRES THEM TO MATCH)
			## Ensure this in: Global_Inventory -> spawnable_items
			if objective.target_id == item_id and objective.target_type == "collection" and not objective.is_completed:
				return true
	return false

# Decrement/Remove item based on name and type
func remove_item(item_name, item_type):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["name"] == item_name and inventory[i]["type"] == item_type:
			inventory[i]["quantity"] -= 1
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
			inventory_updated.emit()
			return true
	return false

# Adds item to hotbar inventory and returns true if successfull
func add_hotbar_item(item):
	for i in range(hotbar_size):
		if hotbar_inventory[i] == null:
			hotbar_inventory[i] = item
			return true
	return false

# Decrement/Remove item based on name and type from hotbar
func remove_hotbar_item(item_name, item_type):
	for i in range(hotbar_inventory.size()):
		if hotbar_inventory[i] != null and hotbar_inventory[i]["name"] == item_name and hotbar_inventory[i]["type"] == item_type:
			if hotbar_inventory[i]["quantity"] <= 0:
				hotbar_inventory[i] = null
			inventory_updated.emit()
			return true
	return false

# Unassign hotbar item
func unassign_hotbar_item(item_name, item_type):
	for i in range(hotbar_inventory.size()):
		if hotbar_inventory[i] != null and hotbar_inventory[i]["name"] == item_name and hotbar_inventory[i]["type"] == item_type:
			hotbar_inventory[i] = null  
			inventory_updated.emit()
			return true
	return false
	
# Prevents duplicate assignments of ites in the hotbar
func is_item_assigned_to_hotbar(item_to_check):
	return item_to_check in hotbar_inventory

# Check the position to test it is valid
func adjust_drop_position(pos):
	var radius = 150
	var nearby_items = get_tree().get_nodes_in_group("Items")
	var attempts = 20  # Limit the number of adjustment attempts to avoid infinite loops

	# Try to find a valid position within the radius
	while attempts > 0:
		var valid_position = true
		
		# Check if any nearby item is too close
		for item in nearby_items:
			if item.global_position.distance_to(pos) < radius:
				var random_offset = Vector2(randf_range(-radius, radius), randf_range(-radius, radius))
				pos += random_offset
				valid_position = false
				break
		
		# Convert the adjusted position back to tile coordinates
		var tile_pos = tile_map.local_to_map(pos)
		var tile_data = tile_map.get_cell_tile_data(tile_pos)

		# Check if the tile is a spawn tile
		if tile_data and tile_data.get_custom_data("SpawnTiles") == true and valid_position:
			return pos  # Return the adjusted position if it's valid
		
		# Decrement attempts if the position was not valid
		attempts -= 1

	# If no valid position was found after attempts, return the original position
	return pos

# Drops an item at a specified position, adjusting for nearby items
func drop_item(item_data, drop_position):
	var item_instance = inventory_item_scene.instantiate()
	
	## Set the data to be used after being dropped
	item_instance.set_item_data(item_data)
	
	## Make sure the drop pos. is valid
	drop_position = adjust_drop_position(drop_position)
	item_instance.global_position = drop_position
	
		# Set the scale to match the inventory item's scale
	if item_data.has("scale"):
		item_instance.scale = item_data["scale"]

	# Set the scale to match the inventory size
	get_tree().current_scene.add_child(item_instance)

# Swap the inventory items based on their resp. indicies
func swap_inventory_items(idx1, idx2):
	if idx1 < 0 or idx1 >= inventory.size() or idx2 < 0 or idx2 >= inventory.size():
		## out of bounds 
		return false
	## Swap the items
	var temp = inventory[idx1]
	inventory[idx1]= inventory[idx2]
	inventory[idx2] = temp
	
	## Emit event
	inventory_updated.emit()
	return true

# Swap the hotbar_inventory items based on their resp. indicies
func swap_hotbar_items(idx1, idx2):
	if idx1 < 0 or idx1 >= hotbar_inventory.size() or idx2 < 0 or idx2 >= hotbar_inventory.size():
		## out of bounds 
		return false
	## Swap the items
	var temp = hotbar_inventory[idx1]
	hotbar_inventory[idx1]= hotbar_inventory[idx2]
	hotbar_inventory[idx2] = temp
	
	## Emit event
	inventory_updated.emit()
	return true

# Add slots to inventory
func increase_inventory_size(added_slots):
	inventory.resize(inventory.size() + added_slots)
	inventory_updated.emit()

# Check if player has key needed to open chest 
func has_key_in_inventory(item_name: String, item_type: String) -> bool:
	for item in inventory:
		if item != null and item["name"] == item_name and item["type"] == item_type:
			return true
	return false

# Get the quantity of an item in the inventory
func get_item_quantity(item_id: String, item_type: String) -> int:
	for item in inventory:
		if item != null and item["id"] == item_id and item["type"] == item_type:
			return item["quantity"]
	return 0

func remove_item_quantity(item_id: String, item_type: String, quantity: int):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["id"] == item_id and inventory[i]["type"] == item_type:
			inventory[i]["quantity"] -= quantity
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
			inventory_updated.emit()
			return
