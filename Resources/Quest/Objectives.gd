## Defines the structure for the Quest objectives including
## their criteria and completion status

extends Resource

class_name Objectives

@export var id: String
@export var description: String
@export var is_completed: bool = false
@export var target_id: String # Item or NPC to talk to or collect
@export var item_type: String # Item type, if collection target type
@export var target_type: String # Either a collection or Talk-to type
@export var required_quantity: int = 1  # optional if collection
@export var collected_quantity: int = 0  # optional if collection
@export var objective_dialog: String = "" # optional if talk_to
