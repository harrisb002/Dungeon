extends StaticBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	# Check if has function
	if body.has_method("player_shop"):
		print("Open the Shop")
