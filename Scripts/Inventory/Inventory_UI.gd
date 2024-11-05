extends Control

@onready var grid_container = $GridContainer

## Stores the current item being dragged/droped
var dragged_slot = null
var drop_target = null

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
	if drop_target and dragged_slot != drop_target:
		# drop the drop slot at target slot
		pass
	dragged_slot = null
