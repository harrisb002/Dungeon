extends Control

@onready var grid_container = $GridContainer

func _ready() -> void:
	# Connect the signal to update and load with correct num of columns
	Global.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()

# Update the inventory UI
func _on_inventory_updated():
	# Clear the current slots
	clear_grid_container()
	
func clear_grid_container():
	while grid_container.get_child_count() > 0:
		var child = grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()
