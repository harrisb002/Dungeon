extends State

@export var inter_card_state: State  # The state for transition after attacks
@export var attack_radius: float = 100.0  # The radius of the attack range

# Cardinal directions (0° for north, 90° for east, 180° for south, 270° for west)
var attack_angles: Array = [0.0, 90.0, 180.0, 270.0]

func enter() -> void:
	super()
	perform_all_attacks()

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	parent.move_and_slide()
	return null

func process_frame(delta: float) -> State:
	return null
	#return inter_card_state

# Perform all 4 attacks at once, in the cardinal directions
func perform_all_attacks() -> void:
	for angle in attack_angles:
		perform_attack(angle)

# Perform the attack in a given direction (based on the angle)
func perform_attack(angle: float) -> void:
	var direction = Vector2(cos(deg_to_rad(angle)), sin(deg_to_rad(angle)))  # Get direction from angle
	var attack_area = RayCast2D.new()  # Use RayCast2D for attack detection (or use Area2D)
	attack_area.cast_to = direction * attack_radius  # Attack in the direction of the angle

	# Spawn the attack or trigger animation/logic here
	# Example: Check for collisions with enemies or deal damage
	print("Attacking in direction: ", angle)
	# Add any effects or collision detection logic (e.g., Area2D detection, RayCast2D checks, etc.)
