extends State

@export var cleave_duration: float = 2.0  # Duration for the cleave attack
@export var second_state: State # State to transition to after the attack
@export var cleave_scene: PackedScene  # Packed scene for Cleave

var attack_timer: Timer = null

func enter() -> void:
	print("CleaveR state entered")
	super()
	print("Performing cleave right attack")
	perform_cleave()

	attack_timer = Timer.new()
	attack_timer.wait_time = cleave_duration
	attack_timer.one_shot = true
	add_child(attack_timer)
	attack_timer.start()

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	parent.move_and_slide()
	return null

func process_frame(delta: float) -> State:
	if attack_timer != null and not attack_timer.is_stopped():
		return null  # Still waiting for the timer
	elif attack_timer != null and attack_timer.is_stopped():
		attack_timer.queue_free()  # Clean up the timer
		return second_state  # Transition to the next state
	return null

func perform_cleave() -> void:
	if parent == null:
		print("Error: Parent is not set. Aborting cleave.")
		return

	if cleave_scene == null:
		print("Error: Cleave scene is not assigned.")
		return

	# Instance the Cleave scene
	var cleave_instance = cleave_scene.instantiate()
	cleave_instance.name = "CleaveR"
	get_tree().root.add_child(cleave_instance)

	# Set position and rotation
	cleave_instance.global_position = parent.global_position

	# Rotate the cleave 180 degrees (mirror it)
	cleave_instance.rotation_degrees = parent.rotation_degrees + 180

	# Apply damage after duration
	if cleave_duration > 0:
		await get_tree().create_timer(cleave_duration).timeout
		cleave_instance.apply_damage()  # Call the damage application method
		cleave_instance.queue_free()
