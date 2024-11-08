extends Control

@onready var icon = $InnerBorder/ItemIcon
@onready var item_name = $DetailsPanel/ItemName
@onready var item_type = $DetailsPanel/ItemType
@onready var item_effect = $DetailsPanel/ItemEffect
@onready var quantity_label = $InnerBorder/ItemQuantity
@onready var details_panel = $DetailsPanel
@onready var usage_panel = $UsagePanel
@onready var assign_button = $UsagePanel/AssignButton
@onready var outer_border = $OuterBorder


signal drag_start(slot)
signal drag_end()

# Slot item
var item = null
var slot_index = -1 # Doesnt exist if still -1

# Keep track of items in hotbar
var is_assigned = false

# Set the slot index for the hotbar
func set_slot_index(new_index):
	slot_index = new_index

# Create empty slots
func set_empty():
	icon.texture = null
	quantity_label.text = ""
	item_name.text = ""
	item_type.text = ""
	item_effect.text = ""
	item = null

# Set slot item with values from dict
func set_item(new_item):
	item = new_item
	## If null set to empty
	if item == null:
		set_empty()
		return

	icon.texture = item["texture"]
	quantity_label.text = str(item["quantity"])
	item_name.text = str(item["name"])
	item_type.text = str(item["type"])
	
	if item["effect"] != "":
		item_effect.text = str(item["effect"])
	else:
		item_effect.text = ""
	
	# Update the assignment text after setting an item
	update_assignment_status()

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
		var drop_position = Global_Player.Player_node.global_position
		## Drop offset from player
		var drop_offset = Vector2(0, 50)
		## Drop in the direction that player is facing
		drop_offset = drop_offset.rotated(Global_Player.Player_node.rotation)
		Global_Inventory.drop_item(item, drop_position + drop_offset)
		Global_Inventory.remove_item(item["name"], item["type"])
		Global_Inventory.remove_hotbar_item(item["name"], item["type"])
		usage_panel.visible = false

# Remove item from inventory, use it and apply effect (if it has one)		
func _on_use_button_pressed():
	usage_panel.visible = false
	## Check if it has an effect before removing it (Dont allow keys to be used in this manner)
	if item != null and item["effect"] != "" and item["effect"] != "Open Chest":
		if Global_Player.Player_node:
			Global_Player.Player_node.apply_item_effect(item)
			Global_Inventory.remove_item(item["name"], item["type"])
			Global_Inventory.remove_hotbar_item(item["name"], item["type"])
		else:
			print("Player could not be found")

# Update text for items assigned or not
func update_assignment_status():
	is_assigned = Global_Inventory.is_item_assigned_to_hotbar(item)
	if is_assigned:
		assign_button.text = "Unassign"
	else:
		assign_button.text = "Assign"

# Assign or unassign hotbar items
func _on_assign_button_pressed():
	if item != null:
		## If item is already assigned then must be removing
		if is_assigned:
			Global_Inventory.unassign_hotbar_item(item["name"], item["type"])
			is_assigned = false
		## Intenting to assign the item to the hotbar
		else:
			Global_Inventory.add_item(item, true)
			is_assigned = true
		## Now update the UI with the changes
		update_assignment_status()

# Used for mouse events for inventory slots (Drag and drop)
func _on_item_button_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		## Usage panel
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if item != null:
				usage_panel.visible = !usage_panel.visible
		## Dragging the item
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				## Change color to show the item is being dragged
				outer_border.modulate = Color(1, 1, 0)
				drag_start.emit(self)
			else:
				## If no longer dragging the item then reset the color
				outer_border.modulate = Color(1, 1, 1)
				drag_end.emit()
				
