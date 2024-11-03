extends Node

# This is a globally autoload script allowing for global access
# This will be responsible for managing the player inventory

# Will be used update the inventory UI
signal inventory_updated

var Player_node: Node = null

@onready var inventory_slot = preload("res://Scenes/Inventory/Inventory_Slot.tscn")

var inventory = []

# Items used to spawn within the area defined (Will update to use tile map later)
var spawnable_items = [
	{"type": "Money", "name": "Coin", "effect": "", "texture": preload("res://allart/InventoryItems/coin.png")},
	{"type": "Key", 	"name": "Common", "effect": "Open Chest", "texture": preload("res://allart/InventoryItems/commonKey.png")},
	{"type": "Potion", "name": "FireSuit", "effect": "Reduce fire damage", "texture": preload("res://allart/InventoryItems/fireResistance.png")},
	{"type": "Potion", "name": "Health Potion", "effect": "+20 Health", "texture": preload("res://allart/InventoryItems/healthPotion.png")},
	{"type": "Potion", "name": "FlashRing", "effect": "Increase Speed", "texture": preload("res://allart/InventoryItems/increaseSpeed.png")},
	{"type": "Potion", "name": "AddedSlots", "effect": "Increase Slots", "texture": preload("res://allart/InventoryItems/inventoryBoost.png")},
	{"type": "Potion", "name": "Cloak", "effect": "Invisible for 20 seconds", "texture": preload("res://allart/InventoryItems/invisibility.png")},
	{"type": "Potion", "name": "Magic Potion", "effect": "Restore mana", "texture": preload("res://allart/InventoryItems/magicPotion.png")},
	{"type": "Potion", "name": "Poison Potion", "effect": "Poison enemy", "texture": preload("res://allart/InventoryItems/poison.png")},
	{"type": "Potion", "name": "Shield Potion", "effect": "+20 Shield", "texture": preload("res://allart/InventoryItems/shieldPotion.png")},
	{"type": "Potion", "name": "Stamina Potion", "effect": "Reduce stamina", "texture": preload("res://allart/InventoryItems/staminaPotion.png")},
	{"type": "Weapon", "name": "Arrow", "effect": "", "texture": preload("res://allart/InventoryItems/arrow.png")},
]



func _ready():
	inventory.resize(9)

# Adds item and returns true if successfull
func add_item(item):
	for i in range(inventory.size()):
		# Stack the item if it already exists in inventory
		# Based on dict. found in inventory_item.gd, pickup_items
		if inventory[i] != null and inventory[i]["name"] == item["name"] and inventory[i]["type"] == item["type"]:
			inventory[i]["quantity"] += item["quantity"]
			inventory_updated.emit()
			print("Item aded", inventory)
			return true
		elif inventory[i] == null:
			inventory[i] = item
			inventory_updated.emit()
			print("Item aded", inventory)
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
	
# Check the position to test it is valid
func adjust_drop_position(pos):
	## Create a drop radius to prevent overlapping
	var radius = 300
	var nearby_items = get_tree().get_nodes_in_group("Items")
	## Make sure its in the spawn area of the radius
	for item in nearby_items:
		if item.global_position.distance_to(pos) < radius:
			var random_offset = Vector2(randf_range(-radius, radius),randf_range(-radius, radius))
			pos += random_offset
			break
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
	get_tree().current_scene.add_child(item_instance)

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
