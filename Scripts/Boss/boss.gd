extends CharacterBody2D

@export var speed = 200
@export var minion_scene: PackedScene
@export var minion_count = 3
@export var projectile: PackedScene
var player_detected = false
var player = null
var minion_timer: Timer
var ranged_attack_timer: Timer
var minions: Array = [] #keep track of spawned minions
var is_attacking: bool = false
var is_shooting: bool = false
@export var attack_range: float = 100.0

func _ready() -> void:
	minion_timer = $Minion_Timer
	minion_timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	minion_timer.stop()
	ranged_attack_timer = $Ranged_Attack
	ranged_attack_timer.connect("timeout", Callable(self, "_on_ranged_attack_timeout"))
	ranged_attack_timer.stop()
	$AnimatedSprite2D.play("idle")

#need to add sprites. Probably attack death walk and idle

#used for moving to player.
func _physics_process(delta: float) -> void:
	if player_detected:
		if position.distance_to(player.position) < attack_range and not is_attacking and not is_shooting:
			attack(1)
		elif not is_attacking:
			
			#Top line will make enemy faster depending on distance
			#position += (player.position - position)/speed
			position += (player.position - position).normalized() * speed * delta
			move_and_collide(Vector2(0,0))
			
			if not is_shooting:
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
	print("Detected body: ", body.name)
	player = body
	player_detected = true

	minion_timer.start()
	ranged_attack_timer.start()

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_detected = false
	minion_timer.stop()
	ranged_attack_timer.stop()
	

#minion stuff
func _on_timer_timeout() -> void:
	#spawn minions here
	spawn_minions()

func spawn_minions() -> void:
	if minion_scene and not are_minions_alive(minion_count):
		var minion = minion_scene.instantiate()
		#minion spawn position
		minion.position = position
		get_parent().add_child(minion)
		minions.append(minion)
		minion_timer.start()
		
func are_minions_alive(max_count: int) -> bool:
	var alive_count = 0
	for minion in minions:
		if minion.is_inside_tree():
			alive_count += 1
		if alive_count >= max_count:
			return true
	return false

#need to add a way to remove minion from array on death
	
	
func attack(attack_type: int):
	#melee attack
	if(attack_type == 1):
		is_attacking = true
		$AnimatedSprite2D.play("melee")
		
		var attack_duration = 1.0
		var timer = get_tree().create_timer(attack_duration)
		await timer.timeout
		
		is_attacking = false
	elif(attack_type == 2):
		ranged_attack()
		
		
		
		

func shoot_arrows(degree_increment: int) -> Node2D:
	var base_angle = (player.position - position).angle()
	var angle_increment = deg_to_rad(degree_increment)

	var projectile_instance = projectile.instantiate()
	projectile_instance.position = position
	projectile_instance.look_at(player.position)
	projectile_instance.rotation += angle_increment


	return projectile_instance


func ranged_attack() -> void:
	is_shooting = true
	speed /= 4
	$AnimatedSprite2D.play("shoot")
	
	while $AnimatedSprite2D.frame < 9:
		await get_tree().process_frame
		
	#makes it stop tracking player on frame 9
	var arrow_left = shoot_arrows(-20)
	var arrow_center = shoot_arrows(0)
	var arrow_right = shoot_arrows(20)
	
	while $AnimatedSprite2D.frame < 11:
		await get_tree().process_frame
	
	get_parent().add_child(arrow_left)
	get_parent().add_child(arrow_center)
	get_parent().add_child(arrow_right)
	
	while $AnimatedSprite2D.frame < 13:
		await get_tree().process_frame
		
	is_shooting = false
	speed *= 4
	
	
func _on_ranged_attack_timeout() -> void:
	ranged_attack_timer.start()
	if not is_attacking and not is_shooting:
		attack(2)
