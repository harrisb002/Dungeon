extends Node

var Player_node: Node = null
var inventory_hotbar = null

# Holds the animation_prefix for the current character selected
var character = ""

# Sets the player reference for inventory interactions
func set_player_ref(player):
	Player_node = player

# Sets the inventory hotbar to hide during interactions
func set_inventory_hotbar(hotbar):
	inventory_hotbar = hotbar
