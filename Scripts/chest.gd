extends StaticBody2D

enum ChestType {COMMON, GOLDEN, BOSS}

signal chest_zone_entered
signal chest_zone_exited

# Chest type default to common, (Can set in Inspector)
@export var chest_type = ChestType.COMMON  

var player_in_range = false

func _ready() -> void:
	$open.visible = false
	$closed.visible = true

func _on_chest_zone_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		emit_signal("chest_zone_entered", self, chest_type)

func _on_chest_zone_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		emit_signal("chest_zone_exited")
