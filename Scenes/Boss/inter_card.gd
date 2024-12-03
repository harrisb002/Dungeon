extends State

@export var indicator_duration: float = 2.0  # Duration for the indicators
@export var attack_angles: Array = [45.0, 135.0, 215.0, 315.0]  # Cardinal directions in degrees

@export var cleaveL_State: State

@export var cone_scene: PackedScene

var attack_timer: Timer = null

func enter() -> void:
	print("card state entered")
	super()
	print("attacking")
	display_attack_indicators()
	
	attack_timer = Timer.new()
	attack_timer.wait_time = indicator_duration
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
		return cleaveL_State
	return null

# Display red triangular indicators in all cardinal directions
func display_attack_indicators() -> void:
	for angle in attack_angles:
		spawn_triangle_indicator(angle)
# Create a triangular indicator for the given angle
func spawn_triangle_indicator(angle: float) -> void:
	if parent == null:
		print("Error: Parent is not set. Aborting triangle creation.")
		return

	var base_cone = cone_scene
	if base_cone == null:
		print("Error: Cone node not found under parent.")
		return

	var cone_instance = cone_scene.instantiate()
	cone_instance.name = "Cone_" + str(angle)
	get_tree().root.add_child(cone_instance)

	# Set position and rotation
	cone_instance.global_position = parent.global_position
	cone_instance.rotation_degrees = angle

	# Remove the cone after duration and apply damage
	if indicator_duration > 0:
		await get_tree().create_timer(indicator_duration).timeout
		cone_instance.apply_damage()  # Call the damage application method
		cone_instance.queue_free()
	

		 
