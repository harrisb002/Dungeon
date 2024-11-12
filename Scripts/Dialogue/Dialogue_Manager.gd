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
		var quest_dialogue = npc.get_current_dialogue()
		if quest_dialogue["text"] != "":
			dialogueUI.show_dialogue(npc.npc_name, quest_dialogue["text"], quest_dialogue["options"])
		# Show dialogues not related to the quest
		else:
			var dialog = npc.get_current_dialog()
			if dialog == null:
				return
			dialogueUI.show_dialogue(npc.npc_name, dialog["text"], dialog["options"])

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
			npc.set_dialogue_tree(npc.current_branch_idx + 1)
		hide_dialogue()
	elif next_state == "exit":
		# Reset curr state to be start
		npc.set_dialogue_state("start")
		hide_dialogue()
	elif next_state == "give_quests":
		## Reached the end of NPC dialogue tree (default branch), then offer all prev. unaccepted quests
		if npc.dialogue_resource.get_npc_dialogue(npc.npc_id)[npc.current_branch_idx]["branch_id"] == "npc_default":
			offer_remaining_quests()
		else:
			## Give the quests available at the curr branch
			offer_quests(npc.dialogue_resource.get_npc_dialogue(npc.npc_id)[npc.current_branch_idx]["branch_id"])
		show_dialogue(npc)
	else:
		show_dialogue(npc)

# Hide the dialogue
func hide_dialogue():
	dialogueUI.hide_dialogue()

# At current branch, offer all curr available quests
func offer_quests(branch_id: String):
	for quest in npc.quests:
		if quest.unlock_id == branch_id and quest.state == "not_started":
			npc.offer_quest(quest.quest_id)
	
# At the default branch, then offer all previously unaccepted quests (Will fix with preReqs later)
func offer_remaining_quests():
	for quest in npc.quests:
		if quest.state == "not_started":
			npc.offer_quest(quest.quest_id)
