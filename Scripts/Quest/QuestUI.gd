extends Control

@onready var panel = $CanvasLayer/Panel
@onready var quest_list = $CanvasLayer/Panel/Contents/Details/Quest_List
@onready var quest_title = $CanvasLayer/Panel/Contents/Details/Quest_Details/Quest_Title
@onready var quest_description = $CanvasLayer/Panel/Contents/Details/Quest_Details/Quest_Description
@onready var quest_objectives = $CanvasLayer/Panel/Contents/Details/Quest_Details/Quest_Objectives
@onready var quest_rewards = $CanvasLayer/Panel/Contents/Details/Quest_Details/Quest_Rewards

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
