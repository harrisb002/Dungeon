extends Area2D




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):#checks if what touched the portal is a player using the group player
		
		body.set_position($Destination_Point.global_position)#sends the player to the marker destintaion that portal contains
