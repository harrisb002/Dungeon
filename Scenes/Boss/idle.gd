extends State

@export
var attack_state: State
@export var detection_range: float = 200.0 
var is_target_in_range: bool = false

func enter() -> void:
	print("idle")
	super()
	parent.velocity = Vector2.ZERO

func process_physics(delta: float) -> State:
	# Check the distance to the player
	var player = get_tree().get_nodes_in_group("player")[0] if get_tree().has_group("player") else null
	if player:
		var distance_to_player = parent.global_position.distance_to(player.global_position)
		if distance_to_player <= detection_range:
			return attack_state
	
	parent.move_and_slide()
	return null
