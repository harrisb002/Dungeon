extends Node

# This is a globally autoload script allowing for global access
# This will be responsible for managing the player inventory

# Will be used update the inventory UI
signal inventory_updated

var Player_node: Node = null
var tile_map: TileMapLayer = null

@onready var inventory_slot_scene = preload("res://Scenes/Inventory/Inventory_Slot.tscn")
@onready var inventory_item_scene = preload("res://Scenes/Inventory/Inventory_Item.tscn")

var inventory = []
var hotbar_size = 5
var hotbar_inventory = []

# Items used to spawn within the area defined (Will update to use tile map later)
var spawnable_items = [
	{"type": "Money", "name": "Coin", "effect": "", "texture": preload("res://allart/InventoryItems/coin.png")},
	{"type": "Common", "name": "Key", "effect": "Open Chest", "texture": preload("res://allart/InventoryItems/commonKey.png")},
	{"type": "Consumable", "name": "Shroom", "effect": "Increase Slots", "texture": preload("res://allart/InventoryItems/inventoryBoost.png")},
	{"type": "Attachment", "name": "Flash Ring", "effect": "Increase Speed", "texture": preload("res://allart/InventoryItems/increaseSpeed.png")},
	{"type": "Weapon", "name": "Arrow", "effect": "", "texture": preload("res://allart/InventoryItems/arrow.png")},
	{"type": "Potion", "name": "Fire Skin", "effect": "Reduce fire damage", "texture": preload("res://allart/InventoryItems/fireResistance.png")},
	{"type": "Potion", "name": "Health Potion", "effect": "+20 Health", "texture": preload("res://allart/InventoryItems/healthPotion.png")},
	{"type": "Potion", "name": "Cloak", "effect": "Invisible for 20 seconds", "texture": preload("res://allart/InventoryItems/invisibility.png")},
	{"type": "Potion", "name": "Magic Potion", "effect": "Restore mana", "texture": preload("res://allart/InventoryItems/magicPotion.png")},
	{"type": "Potion", "name": "Poison Potion", "effect": "Poison enemy", "texture": preload("res://allart/InventoryItems/poison.png")},
	{"type": "Potion", "name": "Shield Potion", "effect": "+20 Shield", "texture": preload("res://allart/InventoryItems/shieldPotion.png")},
	{"type": "Potion", "name": "Stamina Potion", "effect": "Reduce stamina", "texture": preload("res://allart/InventoryItems/staminaPotion.png")},
]

func _ready():
	inventory.resize(9)
	hotbar_inventory.resize(hotbar_size)

# Adds item and returns true if successfull
func add_item(item, to_hotbar = false):
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
				inventory[i]["quantity"] += item["quantity"]
				inventory_updated.emit()
				return true
			elif inventory[i] == null:
				inventory[i] = item
				inventory_updated.emit()
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
	var item_scene = load(item_data["scene_path"])
	var item_instance = item_scene.instantiate()
	
	## Set the data to be used after being dropped
	item_instance.set_item_data(item_data)
	
	## Make sure the drop pos. is valid
	drop_position = adjust_drop_position(drop_position)
	item_instance.global_position = drop_position
	
	# Set the scale to match the inventory size
	item_instance.scale = Vector2(3, 3) 
	get_tree().current_scene.add_child(item_instance)

# Swap the inventory items based on their resp. indicies
func swap_inventory_items(idx1, idx2):
	if idx1 < 0 or idx1 > inventory.size() or idx2 < 0 or idx2 > inventory.size():
		## out of bounds 
		return false
	## Swap the items
	var temp = inventory[idx1]
	inventory[idx1]= inventory[idx2]
	inventory[idx2] = temp
	
	## Emit event
	inventory_updated.emit()
	return true

# Add slots to inventory
func increase_inventory_size(added_slots):
	inventory.resize(inventory.size() + added_slots)
	inventory_updated.emit()

# Sets the player reference for inventory interactions
func set_player_ref(player):
	Player_node = player
	
# Check if player has key needed to open chest 
func has_key_in_inventory(item_name: String, item_type: String) -> bool:
	for item in inventory:
		if item != null and item["name"] == item_name and item["type"] == item_type:
			return true
	return false
