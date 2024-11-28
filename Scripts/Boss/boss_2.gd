class_name Boss_2
extends CharacterBody2D

@onready
var animations = $animations

@onready
var state_machine = $StateMachine

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var attack_state: State
@export var idle_state: State

@export var next_state_index: int = 0
var max_hp = 100
var min_hp = 0
var health = max_hp

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	state_machine.init(self)
	
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	
func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	
	
#func _on_area_2d_body_entered(body: Node2D) -> void:
#	if body.is_in_group("player"):
#		state_machine.change_state(attack_state)

#func _on_area_2d_body_exited(body: Node2D) -> void:
#	if body.is_in_group("player"):
#		state_machine.change_state(idle_state)
	
