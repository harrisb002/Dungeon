extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  

# This function is called when the player dies or the game ends.
func game_over() -> void:
	pass
	
# This function starts a new game.
func new_game() -> void:
	$Player.start() 
	
	$Hud.show_message("Get Ready")
	$Hud.show_message("")
