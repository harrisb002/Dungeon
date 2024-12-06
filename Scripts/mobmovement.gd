extends CharacterBody2D

@export var speed = 250
@export var nav_agent: NavigationAgent2D

signal destroyed

var can_attack = true 
var is_attacking = false
var player =null
var is_player_in_hitbox = false

var health = 0
@export var max_hp = 100
var min_hp = 0

var is_dead = false

@onready var animation =  $Animation
var home_pos = Vector2.ZERO
var steering = Vector2.ZERO
var smoothing_factor = 0.1

func _ready():
	health = max_hp
	home_pos = self.global_position
	nav_agent.path_desired_distance = 4
	nav_agent.target_desired_distance = 4
	_start_random_timer()

	
func _physics_process(delta: float) -> void:
	if is_attacking:
		return
	if nav_agent.is_navigation_finished():
	
		return
	
	var axis = to_local(nav_agent.get_next_path_position()).normalized()

	velocity = speed*axis
	
	if abs(velocity.x) > abs(velocity.y):
		if velocity.x > 0:
			animation.play('Walk')
			animation.flip_h = false 
			##curr_direction = "move_right"
					
		else:
				animation.play('Walk')
				##curr_direction = "move_left"
				animation.flip_h = true 
						
	else:
		if velocity.y > 0:
			animation.play('Walk')
			animation.flip_h = false 
			##curr_direction = "move_down"
						

		else:
			animation.play('Walk')
			animation.flip_h = true 
			##curr_direction = "move_up"
	
		#animation.play('Idle') 
		#velocity = Vector2.ZERO
	
	move_and_slide()




func recalulate_path():
	#print(nav_agent.get_current_navigation_path())
	if player:
		nav_agent.target_position = player.global_position
		#print( "new path",nav_agent.get_current_navigation_path())
	else :
			nav_agent.target_position = home_pos
		
		
		

func _on_timer_timeout() -> void:
	recalulate_path()

func _on_detectionarea_area_entered(area: Area2D) -> void:
	if(area.owner == null):
		return
	
	if area.owner.is_in_group("player")  :
		player = area.owner
		#print("Player detected:", player)



func _on_bodyexited_area_exited(area: Area2D) -> void:
	if area.owner == player :
		player =null
		



func _on_hitbox_area_entered(area: Area2D) -> void:

	if(area.owner == null):
		return
	
	if area.owner.is_in_group("player")  :
		is_player_in_hitbox=true
		is_attacking = true
		$attack_timer.start()
		animation.play('Attack')
		if player != null:
			player.take_damage(10)
		

	
	


func _on_hitbox_area_exited(area: Area2D) -> void:
	if area.owner == player:
		is_player_in_hitbox =false
			
			
		
			
			



func _on_attack_timer_timeout() -> void:
	if not is_player_in_hitbox:
		is_attacking = false
	else:
		$attack_timer.start()
		
func take_damage(dmg: int) -> void:
	
	if not is_dead:
		health -= dmg
		if health <= 0:
			die()
			
func die():
	if is_dead:
		return
	else:	
		emit_signal("destroyed")
		queue_free()
		


func _on_rand_mov_timeout() -> void:
	var random_offset = Vector2(
		randf_range(-150, 150),  # Random offset in the X direction
		randf_range(-150, 150)   # Random offset in the Y direction
	)

	home_pos+=random_offset

	recalulate_path()

func _start_random_timer():
	var random_wait_time = randf_range(5.0,7.0)  # Random wait time between 1 and 3 seconds
	$randMov.wait_time = random_wait_time
	$randMov.start()  # Start the timer with the new wait time
	
