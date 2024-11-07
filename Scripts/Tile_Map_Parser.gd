extends Node2D

@export var target_tile_id: int = 2  # ID of the tiles to filter for items
@export var tile_map: TileMapLayer:
	set(new_tile_map):
		tile_map = new_tile_map

@export var num_items_to_spawn = 10  # Number of items to spawn randomly
@export var items_per_row: int = 12 

func _ready():
	## Init the tile map Globally
	Global.tile_map = tile_map
	create_items()

func create_items():
	#print("Creating Items in TileMapLayer")
	
	var spawnable_cells = []
	for cell in tile_map.get_used_cells():
		var tile_data = tile_map.get_cell_tile_data(cell)
		if tile_data:
			var spawn_tile = tile_data.get_custom_data("SpawnTiles")
			if spawn_tile == true:
				spawnable_cells.append(cell)
	
	spawnable_cells.shuffle()
	var selected_cells = spawnable_cells.slice(0, num_items_to_spawn)
	
	for cell in selected_cells:
		var atlas_coords = Vector2i(cell.x % items_per_row, 0)
		var item_data = Global.spawnable_items[randi() % Global.spawnable_items.size()]
		
		# Print selected cell and its local position
		#print("Selected cell:", cell, "Local Position:", tile_map.map_to_local(cell))

		# Spawn item and place debug marker
		add_item_by_data(cell, item_data, atlas_coords)

func add_item_by_data(cell: Vector2i, item_data: Dictionary, atlas_coords: Vector2i):
	#print("Creating item:", item_data["name"], "at Cell:", cell)
	var item_instance
	
	# Load and instantiate the Inventory_Item scene
	if Global.inventory_item == null:
		print("Error: inventory_item is null in Global script")
	else:
		item_instance = Global.inventory_item.instantiate()
	
	item_instance.set_item_data(item_data)

	# Adjust the item position by using the tile map's local position with a slight offset
	var item_position = tile_map.map_to_local(cell) + Vector2(8, 8)  # Adjust for center

	# Ensure no overlap by adjusting the drop position
	item_position = Global.adjust_drop_position(item_position)
	
	item_instance.position = item_position
	item_instance.scale = Vector2(1, 1)  # Set scale as needed

	add_child(item_instance)
	#print("Item placed at position:", item_position)
