extends Control

@onready var icon = $InnerBorder/ItemIcon
@onready var item_name = $DetailsPanel/ItemName
@onready var item_type = $DetailsPanel/ItemType
@onready var item_effect = $DetailsPanel/ItemEffect
@onready var quantity_label = $InnerBorder/ItemQuantity
@onready var details_panel = $DetailsPanel
@onready var usage_panel = $UsagePanel

# Slot item
var item = null

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
