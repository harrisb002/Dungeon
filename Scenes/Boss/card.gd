extends State

@export var indicator_duration: float = 10.0  # Duration for the indicators
@export var attack_size: float = 500.0  # Size of the triangles
@export var attack_angles: Array = [0.0, 90.0, 180.0, 270.0]  # Cardinal directions in degrees

func enter() -> void:
	print("card state entered")
	super()
	print("attacking")
	display_attack_indicators()

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	parent.move_and_slide()
	return null

func process_frame(delta: float) -> State:
	return null

# Display red triangular indicators in all cardinal directions
func display_attack_indicators() -> void:
	for angle in attack_angles:
		spawn_triangle_indicator(angle)

# Create a triangular indicator for the given angle
func spawn_triangle_indicator(angle: float) -> void:
	print("attack")
	
	if parent == null:
		print("Error: Parent is not set. Aborting triangle creation.")
		return  # Early exit if parent is not assigned
	
	# Print the parent and its position for debugging
	print("Parent: ", parent)
	print("Parent position: ", parent.position)
	
	# Convert angle to a Vector2 direction
	var direction = Vector2(cos(deg_to_rad(angle)), sin(deg_to_rad(angle)))

	# Create a new triangle indicator
	var triangle = Polygon2D.new()
	triangle.polygon = [
		Vector2(0, 0),  # Tip of the triangle
		Vector2(-attack_size / 2, attack_size),  # Left corner
		Vector2(attack_size / 2, attack_size)  # Right corner
	]
	triangle.color = Color(1, 0, 0, 0.8)  # Semi-transparent red

	# Position the triangle at the origin of the boss (parent position)
	var attack_position = parent.position + direction * attack_size * 1.5
	print("Attack position: ", attack_position)

	# Set the triangle's position and rotation
	triangle.position = attack_position
	triangle.rotation = direction.angle()  # direction.angle() returns the angle in radians

	# Set the Z-index to ensure it's visible above other objects
	triangle.z_index = 100  # Increase Z-index for visibility

	# Add the triangle to the parent (the Boss_2 node)
	parent.add_child(triangle)

	# Optionally, remove the indicator after a duration
	if indicator_duration > 0:
		await get_tree().create_timer(indicator_duration).timeout
		triangle.queue_free()
