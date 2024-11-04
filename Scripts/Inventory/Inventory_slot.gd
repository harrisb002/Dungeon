extends Control

@onready var icon = $InnerBorder/ItemIcon
@onready var item_name = $DetailsPanel/ItemName
@onready var item_type = $DetailsPanel/ItemType
@onready var item_effect = $DetailsPanel/ItemEffect
@onready var quantity_label = $InnerBorder/ItemQuantity
@onready var details_panel = $DetailsPanel
@onready var usage_panel = $UsagePanel/AssignButton

# Slot item
var item = null
var slot_index = -1 # Doesnt exist if still -1

# Set the slot index for the hotbar
func set_slot_index(new_index):
	slot_index = new_index

# Create empty slots
func set_empty():
	icon.texture = null
	quantity_label.text = ""

# Set slot item with values from dict
func set_item(new_item):
	item = new_item
	icon.texture = item["texture"]
	quantity_label.text = str(item["quantity"])
	item_name.text = str(item["name"])
	item_type.text = str(item["type"])
	
	if item["effect"] != "":
		item_effect.text = str(item["effect"])
	else:
		item_effect.text = ""

func _on_item_button_pressed():
	# Only show if an item is present
	if item != null:
		# Switch
		usage_panel.visible = !usage_panel.visible

# Used for mouse hovering effect
func _on_item_button_mouse_entered():
	if item != null:
		usage_panel.visible = false
		details_panel.visible = true

func _on_item_button_mouse_exited():
	details_panel.visible = false

# Remove item from inventory and drop it back into the world        		
func _on_drop_button_pressed():
	# Make sure item exists
	if item != null:
		var drop_position = Global.Player_node.global_position
		## Drop offset from player
		var drop_offset = Vector2(0, 50)
		## Drop in the direction that player is facing
		drop_offset = drop_offset.rotated(Global.Player_node.rotation)
		Global.drop_item(item, drop_position + drop_offset)
		Global.remove_item(item["name"], item["type"])
		Global.remove_hotbar_item(item["name"], item["type"])
		usage_panel.visible = false


# Remove item from inventory, use it and apply effect (if it has one)		
func _on_use_button_pressed():
	usage_panel.visible = false
	## Check if it has an effect before removing it (Dont allow keys to be used in this manner)
	if item != null and item["effect"] != "" and item["effect"] != "Open Chest":
		if Global.Player_node:
			Global.Player_node.apply_item_effect(item)
			Global.remove_item(item["name"], item["type"])
			Global.remove_hotbar_item(item["name"], item["type"])
		else:
			print("Player could not be found")


func _on_assign_button_pressed() -> void:
	pass # Replace with function body.
