extends StaticBody2D

enum ChestType {COMMON, GOLDEN, BOSS}

signal chest_zone_entered
signal chest_zone_exited

# Chest type default to common, (Can set in Inspector)
@export var chest_type = ChestType.COMMON  

var player

func _ready() -> void:
	# Get player node
	player = get_tree().root.get_node("Main/Player")  
	$open.visible = false
	$closed.visible = true

# Handles opening all chest types based on keys present in inventory
func _on_player_opening_chest(chest: StaticBody2D) -> void:
	if chest == self:  # Make sure chest instances match
		if player.Keys.has(chest_type):
			# Removes the 1st found key with this type in players inventory.
			player.Keys.erase(chest_type)  
			$open.visible = true
			$closed.visible = false
		else:
			print("You need a ", chest_type, "key to open this chest.")


func _on_chest_zone_body_entered():
	# Pass reference to the chess
	emit_signal("chest_zone_entered", self)

func _on_chest_zone_body_exited():
	emit_signal("chest_zone_exited")
