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

var player_in_range = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if not Engine.is_editor_hint():
		icon_sprite.texture = item_texture

func _process(delta: float):
	# Update and show the updated icon
	if Engine.is_editor_hint():
		icon_sprite.texture = item_texture
		
	if player_in_range and Input.is_action_just_pressed("pickup"):
		pickup_item()

# Creating the dictionary for item information to be passed when adding it
func pickup_item():
	var item = {
		"quantity": 1,
		"item_type": item_type,
		"item_name": item_name,
		"item_texture": item_texture,
		"item_effect": item_effect,
		"scene_path": scene_path,
	}
	if Global.Player:
		# Adding the item to the players inventory
		Global.add_item(item)
		# Remove the item from the scene
		self.queue_free()


func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("Player"):
		player_in_range = true

func _on_area_2d_body_exited(body) -> void:
	if body.is_in_group("Player"):
		player_in_range = false
