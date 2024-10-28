extends Node

# This is a globally autoload script allowing for global access
# This will be responsible for managing the player inventory

# Will be used update the inventory UI
signal inventory_updated

var inventory = []

var Player: Node = null

func _ready():
	inventory.resize(30)

# Adds item and returns true if successfull
func add_item():
	inventory_updated.emit()

func remove_item():
	inventory_updated.emit()

func increase_inventory_size():
	inventory_updated.emit()

func set_player_ref(player):
	Player = player
