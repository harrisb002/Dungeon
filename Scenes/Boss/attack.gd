extends State

@export
var first_state: State
@export
var second_state: State
@export
var third_state: State

var time_waited = 0.0
var waiting_for_delay = false

func enter() -> void:
	print("attack")
	super()
	parent.velocity = Vector2.ZERO

func process_physics(delta: float) -> State:
	parent.move_and_slide()

	# Track waiting time only if delay has started
	if waiting_for_delay:
		time_waited += delta
		if time_waited >= 3.0:
			waiting_for_delay = false
			time_waited = 0.0  # Reset timer
			# Proceed with state decision
			match parent.next_state_index:
				0:
					parent.next_state_index += 1
					return first_state
				1:
					parent.next_state_index += 1
					return second_state
				2:
					parent.next_state_index = 0
					return third_state
		return null
	
	# Start delay for the next transition
	waiting_for_delay = true
	return null
