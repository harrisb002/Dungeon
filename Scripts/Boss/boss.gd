extends CharacterBody2D

@export var speed = 25
var player_detected = false
var player = null

#need to add sprites. Probably attack death walk and idle

#used for moving to player.
func _physics_process(delta: float) -> void:
	if player_detected:
		#Top line will make enemy faster depending on distance
		#position += (player.position - position)/speed
		position += (player.position - position).normalized() * speed * delta
		move_and_collide(Vector2(0,0))
		
		$AnimatedSprite2D.play("walk")
		
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		#need an idle animation currently set to one of knights attacks
		$AnimatedSprite2D.play("idle")




#Detection
func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_detected = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_detected = false
