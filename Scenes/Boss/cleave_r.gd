extends State

@export var cleave_duration: float = 2.0  # Duration for the cleave attack
@export var second_state: State # State to transition to after the attack
@export var cleave_scene: PackedScene  

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
	return null

func process_frame(delta: float) -> State:
	if attack_timer != null and not attack_timer.is_stopped():
		return null  
	elif attack_timer != null and attack_timer.is_stopped():
		attack_timer.queue_free()  
		return second_state  
	return null

func perform_cleave() -> void:
	if parent == null:
		print("Error: Parent is not set. Aborting cleave.")
		return

	if cleave_scene == null:
		print("Error: Cleave scene is not assigned.")
		return

	var cleave_instance = cleave_scene.instantiate()
	cleave_instance.name = "CleaveR"
	get_tree().root.add_child(cleave_instance)

	cleave_instance.global_position = parent.global_position

	cleave_instance.rotation_degrees = parent.rotation_degrees + 180

	if cleave_duration > 0:
		await get_tree().create_timer(cleave_duration).timeout
		cleave_instance.apply_damage()  
		cleave_instance.queue_free()
