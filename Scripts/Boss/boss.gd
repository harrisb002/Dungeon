extends CharacterBody2D

@export var speed = 25
@export var minion_scene: PackedScene
@export var minion_count = 3
var player_detected = false
var player = null
var timer: Timer
var minions: Array = [] #keep track of spawned minions

func _ready() -> void:
	timer = $Timer  # Assuming the Timer node is a direct child
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))


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
	timer.start()
	if not timer.is_stopped():
		timer.stop()  # Stop the timer if it's already running
	timer.start()  # Start or restart the timer

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_detected = false
	timer.stop()
	
	
func _on_timer_timeout() -> void:
	#spawn minions here
	spawn_minions()

func spawn_minions() -> void:
	if minion_scene and not are_minions_alive(minion_count):  # Check if the minion scene is assigned
		var minion = minion_scene.instantiate()
		minion.position = position  # Adjust spawn position as needed
		get_parent().add_child(minion)  # Add minion to the same parent node
		minions.append(minion)
		timer.start()
		
func are_minions_alive(max_count: int) -> bool:
	var alive_count = 0
	for minion in minions:
		if minion.is_inside_tree():
			alive_count += 1
		if alive_count >= max_count:
			return true
	return false
