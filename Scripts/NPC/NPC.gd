extends CharacterBody2D

@export var npc_id: String
@export var npc_name: String

# Dialog vars
@onready var dialogue_manager = $DialogManager
@export var dialogue_resource: Dialog

# Defined in the dialogue JSON
var current_state = "start"
var current_branch_index = 0

func _ready():
	# Loading the dialogue data
	dialogue_resource.load_from_json("res://Resources/Dialog/dialogue_data.json")
	# Init the npc ref
	dialogue_manager.npc = self
	
# Starts the interaction with the NPC
func start_dialogue():
	var npc_dialogues = dialogue_resource.get_npc_dialogue(npc_id)
	if npc_dialogues.is_empty():
		return
	dialogue_manager.show_dialogue(self)

# Get curr branch dialogue
func  get_current_dialogue():
	var npc_dialogues = dialogue_resource.get_npc_dialogue(npc_id) 
	if current_branch_index < npc_dialogues.size():
		for dialogue in npc_dialogues[current_branch_index]["dialogues"]:
			if dialogue["state"] == current_state:
				return dialogue
	return null

# Update dialogue branch
func set_dialogue_tree(branch_index):
	current_branch_index = branch_index
	current_state = "start"

# Update dialogue state
func set_dialogue_state(state):
	current_state = state
