extends StaticBody2D

signal chest_opened

var keyTaken= false

var in_chest_zone = false

func _on_area_2d_body_entered(body: PhysicsBody2D) -> void:
	if keyTaken == false:
		keyTaken = true
		$Sprite2D.queue_free()

func _process(delta: float) -> void:
	if keyTaken == true:
		if in_chest_zone == true:
			if Input.is_action_just_pressed("ui_accept"):
				emit_signal("chest_opened")

func _on_chest_zone_body_entered(body: PhysicsBody2D) -> void:
	in_chest_zone = true

func _on_chest_zone_body_exited(body: PhysicsBody2D) -> void:
	in_chest_zone = true
