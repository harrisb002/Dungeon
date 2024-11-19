extends CharacterBody2D

@export var speed = 250
@export var nav_agent: NavigationAgent2D

var player =null
@onready var animation =  $Animation
var home_pos = Vector2.ZERO

func _ready():

	home_pos = self.global_position
	nav_agent.path_desired_distance = 4
	nav_agent.target_desired_distance = 4
	

	
func _physics_process(delta: float) -> void:
	
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
	else: 
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
