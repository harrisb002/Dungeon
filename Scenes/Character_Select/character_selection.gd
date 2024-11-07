extends Node2D

var main_scene : PackedScene
var chosen = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_scene = preload("res://Scenes/Main.tscn")
	set_all_default()

func set_all_default() -> void:
	$TextureRect/KnightSprite.play("default")
	$TextureRect/MageSprite.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_knight_pressed() -> void:
	set_all_default()
	Global.character = "knight"
	chosen = true
	$TextureRect/KnightSprite.play("selected")

func _on_mage_pressed() -> void:
	set_all_default()
	Global.character = "mage"
	chosen = true
	$TextureRect/MageSprite.play("selected")


func _on_button_pressed() -> void:
	if chosen == true:
		get_tree().change_scene_to_file("res://Scenes/Main.tscn")
