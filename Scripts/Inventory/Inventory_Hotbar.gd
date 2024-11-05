extends Control

@onready var hotbar_container = $HBoxContainer

## Stores the current item being dragged/droped
var dragged_slot = null
var drop_target = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.inventory_updated.connect(_update_hotbar_ui)
	_update_hotbar_ui()
	
# Create the hotbar slots
func _update_hotbar_ui():
	clear_hotbar_container()
	for i in range(Global.hotbar_size):
		var slot = Global.inventory_slot_scene.instantiate()
		# For each slot, set slot index to be able to identify and manage it
		slot.set_slot_index(i)
		
		## Connect each slot to the drag and drop events
		slot.drag_start.connect(_on_drag_start)
		slot.drag_end.connect(_on_drag_end)
		
		hotbar_container.add_child(slot)
		# Check if present and if so, stack it. Else just add it
		if Global.hotbar_inventory[i] != null:
			slot.set_item(Global.hotbar_inventory[i])
		else:
			slot.set_empty()
		slot.update_assignment_status()

# Clear the hotbar slots to use before updating
func clear_hotbar_container():
	while hotbar_container.get_child_count() > 0:
		var child = hotbar_container.get_child(0)
		hotbar_container.remove_child(child)
		child.queue_free()

# Store the dragged slot ref from start
func _on_drag_start(slot_control: Control):
	dragged_slot = slot_control

# Dropping the item (onto world as well)
func _on_drag_end():
	var target_slot = get_slot_under_mouse()
	## Drop into hotbar
	if target_slot and dragged_slot != target_slot:
		drop_slot(dragged_slot, target_slot)
	## Drop onto map
	elif dragged_slot != target_slot:
		var drop_position = Global.Player_node.global_position
		var drop_offset = Vector2(50, 0)
		
		## Drop the Item
		drop_offset = drop_offset.rotated(Global.Player_node.rotation)
		Global.drop_item(dragged_slot.item, drop_position + drop_offset)
		
		## Update both the InventoryUI and the hotbar by removing Item
		Global.remove_item(dragged_slot.item["name"], dragged_slot.item["type"])
		## If the quantity <= 0, unassign and remove the item from the hotbar and inventory
		if dragged_slot.item["quantity"] <= 0:
			Global.unassign_hotbar_item(dragged_slot.item["name"], dragged_slot.item["type"])
			Global.remove_item(dragged_slot.item["name"], dragged_slot.item["type"])
			dragged_slot.set_empty()  # Clear the slot visually
	dragged_slot = null

# Get curr mouse position in the grid container to check if valid (Drop pos.)
func get_slot_under_mouse() -> Control:
	var mouse_position = get_global_mouse_position()
	for slot in hotbar_container.get_children():
		var slot_rect = Rect2(slot.global_position, slot.size)
		if slot_rect.has_point(mouse_position):
			return slot
	return null

# Gets the index of a slot to determine if it is valid 
func get_slot_index(slot: Control) -> int:
	for i in range(hotbar_container.get_child_count()):
		if hotbar_container.get_child(i) == slot:
			## Valid slot is found
			return i
	## Invalid slot 
	return -1

# Drop the selected slot in new slot
func drop_slot(slot1: Control, slot2: Control): 
	## Get the index of the two slots in the gri
	var slot1_idx = get_slot_index(slot1)
	var slot2_idx = get_slot_index(slot2)
	
	if slot1_idx == -1 or slot2_idx == -1:
		print("Invalid slot found")
		return
	else: ## Now attempt to swap the inventory items based on index
		if Global.swap_hotbar_items(slot1_idx, slot2_idx):
			_update_hotbar_ui()
