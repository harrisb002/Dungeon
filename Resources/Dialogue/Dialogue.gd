extends Resource

# Convert to globally accessible class to allow access in other scripts
## Only loaded or made availbale when it is instanced! Not the same as GLobal Singleton
class_name Dialogue

# This will act as a data container (As a resource is) to be shared, saved and reused
# across the diff parts of the game. Usually assigned to nodes via the inspector panel
## Each of the NPC's will be given a new Dialogue instance and this will allow
## for easy loading and managing of the dialogue data for each NPC

# Vars
@export var dialogues = {}

# Loads the Dialog Data
func load_from_json(file_path):
	var data = FileAccess.get_file_as_string(file_path)
	var parsed_data = JSON.parse_string(data)
	if parsed_data:
		dialogues = parsed_data
	else:
		print("Failed to parse JSON: ", parsed_data)

# Returns the individual NPC dialogues
func get_npc_dialogue(npc_id):
	if npc_id in dialogues:
		return dialogues[npc_id]["trees"]
	else:
		return []
