@tool ## Executes the code while in editor (No need to run game to see changes)
extends Area2D

# Vars
@export var item_id: String = ""
@export var item_quantity: int = 1 
@export var item_icon = Texture2D
@onready var sprite_2d = $Sprite2D

func _ready():
	## Shows the texture in game
	if not Engine.is_editor_hint():
		sprite_2d.set_texture(item_icon)

func _process(_delta):
	## Shows the texture in editor
	if Engine.is_editor_hint():
		sprite_2d.set_texture(item_icon)
