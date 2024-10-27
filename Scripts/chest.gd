extends StaticBody2D

func _ready() -> void:
	$open.visible = false
	$closed.visible = true


func _on_key_chest_opened() -> void:
	$open.visible = true
	$closed.visible = false
