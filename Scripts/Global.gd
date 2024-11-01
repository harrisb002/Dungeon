extends Node

# This is a globally autoload script allowing for global access
# This will be responsible for managing the player inventory

# Will be used update the inventory UI
signal inventory_updated

@onready var inventory_slot = preload("res://Scenes/Inventory/Inventory_Slot.tscn")

var inventory = []

var Player: Node = null

func _ready():
	inventory.resize(30)

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
			if inventory[i] <= 0:
				inventory[i] = null
			inventory_updated.emit()
			return true
	return false
	
# Check the position to test it is valid
func adjust_drop_position(pos):
	## Create a drop radius to prevent overlapping
	var radius = 25
	var nearby_items = get_tree().get_nodes_in_group("Items")
	## Make sure its in the spawn area of the radius
	for item in nearby_items:
		if item.global_position.distance_to(pos) < radius:
			var random_offset = Vector2(randf_range(-radius, radius),randf_range(-radius, radius))
			pos += random_offset
			break
	return pos

func increase_inventory_size():
	inventory_updated.emit()

func set_player_ref(player):
	Player = player
