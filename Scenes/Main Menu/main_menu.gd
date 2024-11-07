class_name mainMenu
extends Control

@onready var start_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var exit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button as Button
@onready var start_level = preload("res://Scenes/Character_Select/character_selection.tscn") as PackedScene





## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	start_button.button_down.connect(on_start_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	#pass # Replace with function body.
#
func on_start_pressed() -> void:
	
	get_tree().change_scene_to_packed(start_level)
	#pass
	
func on_exit_pressed() -> void:
	
	get_tree().quit()
	#pass
	
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
