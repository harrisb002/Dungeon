extends CharacterBody2D

@export var speed = 200
var CONST_SPEED: int = speed
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
var is_dashing: bool = false
@export var attack_range: float = 100.0
var dash_range: float = 400
var alive_count = 0
var dash_direction

var melee_count = 0


#TODO: add stagger mech
#TODO: change minions to tornados which stop player movement when hit
#TODO: add wall when using shockwave attack so player cant just walk behind
#TODO: maybe add big arrow attack down the middle after the second dodge and replace the idle animation with this attack animation
#TODO: stuff on death
#TODO: fix boss being pushed by player

func _ready() -> void:
	CONST_SPEED = speed
	minion_timer = $Minion_Timer
	minion_timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	minion_timer.stop()
	ranged_attack_timer = $Ranged_Attack
	ranged_attack_timer.connect("timeout", Callable(self, "_on_ranged_attack_timeout"))
	ranged_attack_timer.stop()
	$AnimatedSprite2D.play("idle")

func dash_attack() -> void:
	is_dashing = true
	$AnimatedSprite2D.play("dash")
	dash_direction = (player.position - position).normalized()

#used for moving to player.
func _physics_process(delta: float) -> void:
	move_and_collide(Vector2(0,0))
	if is_dashing:
		position += dash_direction * speed * 5 * delta
		
		if $AnimatedSprite2D.frame == 5:
			is_dashing = false
			
	elif player_detected:
		if position.distance_to(player.position) < attack_range and not is_attacking and not is_shooting:
			if melee_count == 3:
				attack(3)
			else:
				attack(1)
			
		elif not is_attacking:
			
			#Top line will make enemy faster depending on distance
			#position += (player.position - position)/speed
			position += (player.position - position).normalized() * speed * delta
			
			
			if not is_shooting:
				$AnimatedSprite2D.play("walk")
			
			if(player.position.x - position.x) < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")


#Detection
func _on_detection_area_body_entered(body: Node2D) -> void:
	#print("Detected body: ", body.name)
	player = body
	player_detected = true

	minion_timer.start()
	ranged_attack_timer.start()

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_detected = false
	minion_timer.stop()
	ranged_attack_timer.stop()
	is_attacking = false
	is_shooting = false
	speed = CONST_SPEED

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
		while $AnimatedSprite2D.frame < 4:
			await get_tree().process_frame
		
		var attack_duration = .3
		var timer = get_tree().create_timer(attack_duration)
		await timer.timeout
		#TODO: maybe add animation pause here?
		is_attacking = false
		melee_count += 1
		#print (melee_count)
	elif(attack_type == 2):
		ranged_attack()
		
	elif(attack_type == 3):
		melee_count = 0
		is_attacking = true
		$AnimatedSprite2D.play("aoe_attack")
		if $AnimatedSprite2D.frame < 1:
			shockwave_attack()
			await get_tree().process_frame
			$AnimatedSprite2D.pause()
			await get_tree().create_timer(.8).timeout
			$AnimatedSprite2D.play()
		while $AnimatedSprite2D.frame < 4:
			await get_tree().process_frame
		#code for dmg and stuff
		
		$AnimatedSprite2D.play("idle")
		await get_tree().create_timer(2.2).timeout
		is_attacking = false
		
#This will probably just be an indicator for the attack
#Will probably make a collision thing with a texture/animated sprite for actual attack
func shockwave_attack():
	var direction_to_player = (player.position - position).normalized()
	var shockwave_length = 700
	var point_a = position
	var point_b = position + direction_to_player * shockwave_length
	var width = 70.0
	
	var shockwave_indicator = Line2D.new()
	shockwave_indicator.default_color = Color(1, 0, 0, 0.3)
	shockwave_indicator.width = width
	shockwave_indicator.points = [point_a, point_b]
	get_parent().add_child(shockwave_indicator)
	
	await get_tree().create_timer(1.5).timeout
	#code here for dmg if player in thing
	#will probably just call a scene which will damage the player and have a sprite
	shockwave_indicator.queue_free()
	
	var offset_distance = 120
	var left_point = position + direction_to_player.rotated(deg_to_rad(90)) * offset_distance
	var right_point = position + direction_to_player.rotated(deg_to_rad(-90)) * offset_distance
	var width2 = 150
	
	var left_shockwave = Line2D.new()
	left_shockwave.default_color = Color(1, 0, 0, 0.3)
	left_shockwave.width = width2
	left_shockwave.points = [left_point, left_point + direction_to_player * shockwave_length]
	get_parent().add_child(left_shockwave)
	
	var right_shockwave = Line2D.new()
	right_shockwave.default_color = Color(1, 0, 0, 0.3)
	right_shockwave.width = width2
	right_shockwave.points = [right_point, right_point + direction_to_player * shockwave_length]
	get_parent().add_child(right_shockwave)
	
	await get_tree().create_timer(1.5).timeout
	#code here for dmg if player in thing
	left_shockwave.queue_free()
	right_shockwave.queue_free()
	

func shoot_arrows(degree_increment: int) -> Node2D:
	var base_angle = (player.position - position).angle()
	var angle_increment = deg_to_rad(degree_increment)

	var projectile_instance = projectile.instantiate()
	projectile_instance.position = position
	projectile_instance.look_at(player.position)
	projectile_instance.rotation += angle_increment
	
	return projectile_instance

func display_arrow_path(degree_increment: int) -> void:
	#made line2d here instead of new scene.
	#can easaly be changed into a new scene if needed for other scenes
	var line = Line2D.new()
	line.default_color = Color.RED
	line.width = 2.0
	
	var line_length = 6000

	var base_angle = (player.position - position).angle()
	var angle_increment = deg_to_rad(degree_increment)
	
	var end_position = position + Vector2.RIGHT.rotated(base_angle + angle_increment) * line_length
	line.points = [position, end_position]

	get_parent().add_child(line)

	await get_tree().create_timer(0.5).timeout
	line.queue_free()

func ranged_attack() -> void:
	is_shooting = true
	
	$AnimatedSprite2D.play("run")
	speed *= -1.5
	
	var run_duration = 2
	var retreat_timer = get_tree().create_timer(run_duration)
	await retreat_timer.timeout
	
	speed = CONST_SPEED
	if is_shooting:
		speed /= 4
		$AnimatedSprite2D.play("shoot")
		
		while $AnimatedSprite2D.frame < 9:
			await get_tree().process_frame
			
		#makes it stop tracking player on frame 9
		var arrow_left = shoot_arrows(-20)
		var arrow_center = shoot_arrows(0)
		var arrow_right = shoot_arrows(20)
		display_arrow_path(-20)
		display_arrow_path(0)
		display_arrow_path(20)
		
		while $AnimatedSprite2D.frame < 11:
			await get_tree().process_frame
		
		get_parent().add_child(arrow_left)
		get_parent().add_child(arrow_center)
		get_parent().add_child(arrow_right)
		
		while $AnimatedSprite2D.frame < 13:
			await get_tree().process_frame
			
		if position.distance_to(player.position) > dash_range:
			dash_attack()
			
		ranged_attack_timer.stop()
		ranged_attack_timer.start()
		
		is_shooting = false
		speed = CONST_SPEED
	
	
func _on_ranged_attack_timeout() -> void:
	ranged_attack_timer.start()
	if not is_attacking and not is_shooting:
		attack(2)
		
