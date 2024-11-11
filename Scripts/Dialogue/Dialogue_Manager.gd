extends Node2D

@onready var dialogueUI = $DialogueUI

# NPC being interacted with
var npc: Node = null

# Show the dialog with data
func show_dialogue(npc, text = "", options = {}):
	if text != "":
		# Display an empty box
		dialogueUI.show_dialogue(npc.npc_name, text, options)
	else:
		# Show the populated data by fetching data
		# Returns the curr data based on the state of dialogue tree
		var dialogue = npc.get_current_dialogue()
		if dialogue == null:
			return # Ends the dialogue
		dialogueUI.show_dialogue(npc.npc_name, dialogue["text"], dialogue["options"])

# Manangement for dialogue state
func handle_dialogue_choice(option):
	# Fetch the current dialogue branch for the current interaction
	var currrent_dialogue = npc.get_current_dialogue()
	if currrent_dialogue == null:
		return
	
	# Update the state
	var next_state = currrent_dialogue["options"].get(option, "start")
	npc.set_dialogue_state(next_state)
	
	if next_state == "end":
		if npc.current_branch_idx < npc.dialogue_resource.get_npc_dialogue(npc.npc_id).size() - 1:
			npc.set_dialogue_branch(npc.current_branch_idx + 1)
		hide_dialogue()
	elif next_state == "exit":
		# Reset curr state to be start
		npc.set_dialogue_state("start")
		hide_dialogue()
	elif next_state == "give_quest":
		pass
	else:
		show_dialogue(npc)
	
# Hide the dialogue
func hide_dialogue():
	dialogueUI.hide_dialogue()
