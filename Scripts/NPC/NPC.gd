extends CharacterBody2D

@export var npc_id: String
@export var npc_name: String

# Dialog vars
@onready var dialogue_manager = $Dialogue_Manager

# Instance the Dialogue resource using class name
@export var dialogue_resource: Dialogue

# Quest vars
@export var quests: Array[Quest] = []
var quest_manager: Node = null

# Defined in the dialogue JSON
var current_state = "start"
var current_branch_idx = 0

func _ready():
	# Loading the dialogue data
	dialogue_resource.load_from_json("res://Resources/Dialogue/dialogue_data.json")
	# Init the npc ref
	dialogue_manager.npc = self
	# Get the quest manager form the player node via global
	quest_manager = Global_Player.Player_node.quest_manager
	print("NPC is ready, quests are loaded: ", quests.size())

# Starts the interaction with the NPC
func start_dialogue():
	var npc_dialogues = dialogue_resource.get_npc_dialogue(npc_id)
	if npc_dialogues.is_empty():
		return
	dialogue_manager.show_dialogue(self)

# Get curr branch dialogue
func  get_current_dialogue():
	var npc_dialogues = dialogue_resource.get_npc_dialogue(npc_id) 
	if current_branch_idx < npc_dialogues.size():
		for dialogue in npc_dialogues[current_branch_idx]["dialogues"]:
			if dialogue["state"] == current_state:
				return dialogue
	return null

# Offer quest at required branch
func offer_quest(quest_id: String):
	# Make sure NPC is trying to give player the quest
	print("Attempting to offer quest: ", quest_id)
	# Loop through NPC's quests (added in the inspector panel)
	for quest in quests:
		# Check if their are any at this curr branch that have not been started
		if quest.quest_id == quest_id and quest.state == "not_started":
			# Give the player the quest
			quest.state = "in_progress"
			quest_manager.add_quest(quest)
			return
	print("Quest not found or started already")

# Returns quest dialogue (Also if the NPC may be a talk_to objective)
func get_quest_dialogue() -> Dictionary:
	# Check the active quest curr in progress which is the selected quest
	var active_quests = quest_manager.get_active_quests()
	for quest in active_quests:
		# Then check objectives of the active quest
		for objective in quest.objectives:
			# If the obj. has not been started or completed, & the target is the curr NPC
			if objective.target_id == npc_id and objective.target_type == "talk_to" and not objective.is_completed:
				if current_state == "start":
					# Return the obj. dialogue in the dialogueUI by passing the text & options
					# Only play once for when the objective is not yet complete
					return {"text": objective.objective_dialog, "options": {}}
					
	# Return any other data in the JSON file if nothing found
	return {"text": "", "options": {}}

# Update dialogue branch
func set_dialogue_tree(branch_index):
	current_branch_idx = branch_index
	current_state = "start"

# Update dialogue state
func set_dialogue_state(state):
	current_state = state
