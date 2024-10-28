@tool
extends Node2D

# Export, Allows setting it through the inspector
@export var item_name = ""
@export var item_type = ""
@export var item_texture = Texture
@export var item_effect = ""
var scene_path: String =  "res://Scenes/inventory_item.tscn"

# Allow for dynamically changed sprites
@onready var icon_sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if not Engine.is_editor_hint():
		icon_sprite.texture = item_texture

func _process(delta: float):
	# Update and show the updated icon
	if Engine.is_editor_hint():
		icon_sprite.texture = item_texture
