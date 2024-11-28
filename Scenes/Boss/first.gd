extends State

@export
var card_state: State
var time_waited = 0.0

func enter() -> void:
	print("first")
	super()
	#parent.velocity = Vector2.ZERO

func process_physics(delta: float) -> State:
	parent.move_and_slide()
	return null
	
func process_frame(delta: float) -> State:
	print("process_frame in first_state")  # Debug print
	time_waited += delta
	print("Time waited: ", time_waited)  # Debug print
	if time_waited >= 3.0:
		print("timer done")
		return card_state
	return null
