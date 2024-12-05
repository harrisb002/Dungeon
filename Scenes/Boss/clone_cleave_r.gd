extends State

@export
var cloneIn_state: State
var time_waited = 0.0

func enter() -> void:
	pass

func process_physics(delta: float) -> State:
	parent.move_and_slide()
	return null
	
func process_frame(delta: float) -> State:
	return null
