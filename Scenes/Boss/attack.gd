extends State

@export
var first_state: State
@export
var second_state: State
@export
var third_state: State

func enter() -> void:
	super()
	parent.velocity = Vector2.ZERO

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	parent.move_and_slide()
	await get_tree().create_timer(3.0).timeout
	#Decide which state to go to based on the parent's next_state_index
	match parent.next_state_index:
		0:
			parent.next_state_index += 1
			return first_state
		1:
			parent.next_state_index += 1
			return second_state
		2:
			parent.next_state_index = 0  #Reset to loop. Change to enrage later?
			return third_state
			
	return null
