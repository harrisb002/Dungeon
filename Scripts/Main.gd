extends Node

# Node References for spawning items on map
#@onready var items = $Items
#@onready var item_spawn_area = $Item_Spawn_Area
#@onready var collision_shape = $Item_Spawn_Area/CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#spawn_random_items(5)  
	$Player.start() 
	pass

# This function starts a new game.
func new_game() -> void:
	pass

# Logic for spawning items using shape
## Get a random pos. for the item within the collision shape
#func get_random_position():
	#var area_rect = collision_shape.shape.get_rect()
	#var x = randf_range(0, area_rect.position.x)
	#var y = randf_range(0, area_rect.position.y)
	#
	## Spawn the item within the bounds
	#return item_spawn_area.to_global(Vector2(x, y))

## Create instance of Item scene on the map underneath /Items node
#func spawn_item(data, position):
	#var item_scene = preload("res://Scenes/Inventory/Inventory_Item.tscn")
	#var item_instance = item_scene.instantiate()
	#item_instance.initiate_items(data["type"], data["name"], data["effect"], data["texture"])
	#item_instance.global_position = position
	#items.add_child(item_instance)

## This does cause duplication! Since the num of items < count
## Randomly choose an item to spawn
#func spawn_random_items(count):
	#var attempts = 0
	#var spawned_count = 0
	## Setting the amount tries to find position to 100
	#while spawned_count < count and attempts < 100:
		#var pos = get_random_position()
		#spawn_item(Global.spawnable_items[randi() % Global.spawnable_items.size()], pos)
		#spawned_count += 1
		#attempts += 1
