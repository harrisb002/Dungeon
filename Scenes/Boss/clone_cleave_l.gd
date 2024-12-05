extends State

@export var cleave_duration: float = 2.0  # Duration for the cleave attack
@export var cloneCleaveR_state: State  # State to transition to after the attack
@export var cleave_scene: PackedScene 

var attack_timer: Timer = null

func enter() -> void:
	print("Cleave state entered")
	super()
	print("Performing cleave attacks")
	perform_cleave_attacks()

	attack_timer = Timer.new()
	attack_timer.wait_time = cleave_duration
	attack_timer.one_shot = true
	add_child(attack_timer)
	attack_timer.start()

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	return null

func process_frame(delta: float) -> State:
	if attack_timer != null and not attack_timer.is_stopped():
		return null  
	elif attack_timer != null and attack_timer.is_stopped():
		attack_timer.queue_free()  
		return cloneCleaveR_state  
	return null

func perform_cleave_attacks() -> void:
	perform_cleave(parent.global_position, 0.0)
	
	# Northwest cleave (rotated 135 degrees)
	var offset = Vector2(-100, -100)  # Offset
	perform_cleave(parent.global_position + offset, 135.0)

func perform_cleave(position: Vector2, rotation: float) -> void:
	if parent == null:
		print("Error: Parent is not set. Aborting cleave.")
		return

	if cleave_scene == null:
		print("Error: Cleave scene is not assigned.")
		return

	var cleave_instance = cleave_scene.instantiate()
	cleave_instance.name = "Cleave"
	get_tree().root.add_child(cleave_instance)

	cleave_instance.global_position = position
	cleave_instance.rotation_degrees = rotation

	if cleave_duration > 0:
		await get_tree().create_timer(cleave_duration).timeout
		cleave_instance.apply_damage() 
		cleave_instance.queue_free()
