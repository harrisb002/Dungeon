## Defines the quest structure including its objectives and rewards

extends Resource

class_name Quest

@export var quest_id: String
@export var quest_name: String
@export var quest_description: String
@export var state: String = "not_started"

## ID of the dialogue branch that the player should 
## be at to be able to accept this quest
@export var unlock_id: String  

@export var objectives: Array[Objectives] = []
@export var rewards: Array[Rewards] = []

# Checks completed objectives
func is_completed() -> bool:
	for objective in objectives:
		if not objective.is_completed:
			return false
	return true

# Completes objectives
func complete_objective(objective_id: String, quantity: int = 1):
	for objective in objectives:
		## Get what objective is being completed 
		if objective.id == objective_id:
			if objective.target_type == "collection":
				objective.collected_quantity += quantity
				if objective.collected_quantity >= objective.required_quantity:
					objective.is_completed = true
					## Update inventory (Using name of item and type)
					print("Removing Item from inventory due to quest completion.")
					Global_Inventory.remove_item(objective.target_id, objective.item_type)
			else:
				## Just talking to an NPC so just mark as completed
				objective.is_completed = true
			break
	if is_completed():
		state = "completed"
