extends State

@export
var card_state: State
var time_waited = 0.0

func enter() -> void:
	super()
	#parent.velocity = Vector2.ZERO

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	parent.move_and_slide()
	return null
	
func process_frame(delta: float) -> State:
	time_waited += delta
	if time_waited >= 3.0:
		return card_state
	return null
