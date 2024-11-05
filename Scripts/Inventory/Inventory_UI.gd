extends Control

@onready var grid_container = $GridContainer

## Stores the current item being dragged/droped
var dragged_slot = null

func _ready():
	# Connect the signal to update and load with correct num of columns
	Global.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()
	
# Update the inventory UI
func _on_inventory_updated():
	# Clear the current slots
	clear_grid_container()
	
	# Add slots for each inventory item
	for item in Global.inventory:
		# Create new slot scene and add it to container
		var slot = Global.inventory_slot_scene.instantiate()
		
		## Connect each slot to the drag and drop events
		slot.drag_start.connect(_on_drag_start)
		slot.drag_end.connect(_on_drag_end)
		
		grid_container.add_child(slot)
		if item != null:
			slot.set_item(item)
		else:
			slot.set_empty()

# Clear grid upon each update to ensure correct quantity
func clear_grid_container():
	while grid_container.get_child_count() > 0:
		var child = grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()

# Store the dragged slot ref from start
func _on_drag_start(slot_control: Control):
	dragged_slot = slot_control
	print("Draggin started from slot: ", dragged_slot)

# Dropping the item 
func _on_drag_end():
	## Get the pos. of the drop target
	var target_slot = get_slot_under_mouse()
	if target_slot and dragged_slot != target_slot:
		# drop the drop slot at target slot
		drop_slot(dragged_slot, target_slot)
	dragged_slot = null

# Get curr mouse position in the grid container to check if valid (Drop pos.)
func get_slot_under_mouse() -> Control:
	var mouse_position = get_global_mouse_position()
	for slot in grid_container.get_children():
		var slot_rect = Rect2(slot.global_position, slot.size)
		if slot_rect.has_point(mouse_position):
			return slot
	return null

# Gets the index of a slot to determine if it is valid 
func get_slot_index(slot: Control) -> int:
	for i in range(grid_container.get_child_count()):
		if grid_container.get_child(i) == slot:
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
		if Global.swap_inventory_items(slot1_idx, slot2_idx):
			_on_inventory_updated()
