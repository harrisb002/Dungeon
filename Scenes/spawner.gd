extends Node2D

# Preloaded enemy scenes

# Timer node reference
@onready var spawn_timer = $Timer  # Assuming you have a Timer node named "Timer" in the scene

var shape 
var can_spawn = true
# List of enemies to spawn
var enemies = [preload("res://Scenes/Mobscenes/eyebat.tscn"), preload("res://Scenes/Mobscenes/fireworm.tscn"), preload("res://Scenes/Mobscenes/mushroom.tscn"),  preload("res://Scenes/Mobscenes/goblin.tscn")]

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	shape = get_node("Area2D/CollisionShape2D")
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_random_point_within_area() -> Vector2:
	
	
	if shape is CircleShape2D:
 		# If the shape is a circle
		var radius = shape.radius
		var angle = randf_range(0, 2 * PI)  # Random angle between 0 and 2 * PI
		var distance = randf_range(0, radius)  # Random distance from the center
		var random_x = cos(angle) * distance
		var random_y = sin(angle) * distance
		return shape.position + Vector2(random_x, random_y)
	else:
		return shape.position 
		
# Function to spawn an enemy at a random position
func _spawn_enemy() -> void:

	var num_enemies = randi() %  3+ 2
	
	# Loop to spawn the random number of enemies
	for i in range(num_enemies):
		# Randomly select an enemy scene
		var enemy_scene = enemies[randi() % enemies.size()]

		# Get a random position within the area
		var spawn_position = get_random_point_within_area()

		# Add an offset to avoid stacking
		var offset_x = randf_range(-50, 50)  # Random offset in the X direction
		var offset_y = randf_range(-50, 50)  # Random offset in the Y direction
		spawn_position += Vector2(offset_x, offset_y)

		# Instantiate the enemy
		var enn = enemy_scene.instantiate()

		# Set the enemy's position
	

		enn.position = spawn_position
		
		# Add the enemy to the scene
		add_child(enn)
		


# Timer timeout callback to spawn enemies periodically


func _on_area_2d_area_entered(area: Area2D) -> void:
	
	if area.owner != null and area.owner.is_in_group("player") and can_spawn:
		_spawn_enemy() 
		can_spawn = false
		$spawnlock.start()
		
	else:
		return 



func _on_spawnlock_timeout() -> void:
	can_spawn = true  # Allow spawning again after the timer finishes
	print("Spawn lock released! Ready for new spawn.")
