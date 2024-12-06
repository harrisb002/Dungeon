extends State

@export
var cloneSpawn_state: State
var time_waited = 0.0

func enter() -> void:
	print("second")
	super()
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
	
func process_frame(delta: float) -> State:
	return cloneSpawn_state
