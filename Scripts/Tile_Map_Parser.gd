extends Node2D

@export var item_mapping: ItemMapping
@export var items_layer_name = "Spawn_Items"
@export var target_tile_id: int = 2  # ID of the tiles to filter for items
@export var tile_map: TileMapLayer:
	set(new_tile_map):
		tile_map = new_tile_map
		create_items()

# Define numb of items (columns) in the atlas row
@export var items_per_row: int = 12 

func create_items():
	print("Creating Items in TileMapLayer")
	# Iterate through all cells with tiles in this layer
	for cell in tile_map.get_used_cells():
		var source_id = tile_map.get_cell_source_id(cell)
		if source_id == target_tile_id:
			# Get atlas coordinates based on cell's index
			var atlas_coords = Vector2i(cell.x % items_per_row, 0)  # Column index, row is 0
			print("SourceID:", source_id, "Atlas Coords:", atlas_coords)
			
			# Map atlas_coords.x to an item in the spawnable_items array
			var item_data = Global.spawnable_items[atlas_coords.x] if atlas_coords.x < Global.spawnable_items.size() else null
			if item_data:
				print("Creating item:", item_data["name"], "at Cell:", cell, "with Atlas Coords:", atlas_coords)
				add_item_by_data(cell, item_data, atlas_coords)
			else:
				print("Invalid item ID at Atlas Coords:", atlas_coords.x)
		else:
			print("No matching tile ID at Cell:", cell)

func add_item_by_data(cell: Vector2i, item_data: Dictionary, atlas_coords: Vector2i):
	print("Creating item:", item_data["name"], "with effect:", item_data["effect"], "at position:", cell)
	# item creation logic, using item_data and atlas_coords
