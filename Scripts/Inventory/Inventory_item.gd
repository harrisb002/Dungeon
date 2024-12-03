@tool
extends Node2D

var scene_path: String =  "res://Scenes/Inventory/Inventory_Item.tscn"

# Allow for dynamically changed sprites
@onready var icon_sprite = $Sprite2D

var player_in_range = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if not Engine.is_editor_hint():
		icon_sprite.texture = Global_Inventory.item_texture

func _process(delta: float):
	# Update and show the updated icon
	if Engine.is_editor_hint():
		icon_sprite.texture = Global_Inventory.item_texture
		
	if player_in_range and Input.is_action_just_pressed("pickup"):
		pickup_item()

# Create the dict for item info to be passed when adding it
func pickup_item(): 
	var item = {
		"id": Global_Inventory.item_id,
		"quantity": 1,
		"type": Global_Inventory.item_type,
		"name": Global_Inventory.item_name,
		"texture": Global_Inventory.item_texture,
		"effect": Global_Inventory.item_effect,
		"scene_path": scene_path,
		"scale": scale  # Used when dropping items
	}
	if Global_Player.Player_node:
		# Adding item to players inventory
		Global_Inventory.add_item(item, false)
		# Remove item from scene
		self.queue_free()

func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		body.interact_ui_label.text = "Press Enter to pick up"
		body.interact_ui.visible = true

func _on_area_2d_body_exited(body) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		body.interact_ui.visible = false
