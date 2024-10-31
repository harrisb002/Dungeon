extends CharacterBody2D

# Send signal to try to open chest
signal openingChest

@export var speed = 700  # How fast the player will move (pixels/sec).

# Delays the nodes initialization until its added to the scene
@onready var animated_sprite = $AnimatedSprite2D
@onready var interact_ui = $InventoryUI


var screen_size  # Size of the game window.
var start_position = Vector2.ZERO  # Variable to store the player's starting position
var original_scale = Vector2.ONE  # Variable to store the player's original scale
var inside_hole = false # Flag for falling in holes

var curr_direction = "move_right" # Check what side we are currenlty moving 
var is_attacking = false  # Check if attack frames are on

var Keys = [] # Contains all collected keys

# Store specific chest the player is near
var nearby_chest = null  

# Run as soon as the object/scene is ready in the game, done before everything else
func _ready():
	# Set the Player reference instance to access the player globally
	Global.set_player_ref(self)
	
	screen_size = get_viewport_rect().size
	original_scale = scale  # Store the player's original scale
	start_position = position  # Store the player's start position
	hide() # Hide the player at the start of the game
	
# Detect whether a key is pressed using Input.is_action_pressed(),
#   which returns true if it is pressed or false if it isn’t.
func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
	update_animations()
	attack()

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed
	
func update_animations():
	if is_attacking:
		return  
	if inside_hole:
		fall()
		
	if velocity == Vector2.ZERO:
		# Default to the right
		animated_sprite.stop()
	else:
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				animated_sprite.play("right")
				curr_direction = "move_right"
			else:
				animated_sprite.play("left")
				curr_direction = "move_left"
		else:
			if velocity.y > 0:
				animated_sprite.play("forward")
				curr_direction = "move_down"
			else:
				animated_sprite.play("backward")
				curr_direction = "move_up"
	
func attack():
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true  # Set the flag to true
		if(curr_direction == "move_right") :
			animated_sprite.play("right_attack")
			$attack_time_out.start()
		if(curr_direction == "move_left") :
			animated_sprite.play("left_attack")
			$attack_time_out.start()
		if(curr_direction == "move_down"):
			animated_sprite.play("forward_attack")
			$attack_time_out.start()
		if(curr_direction == "move_up"):
			animated_sprite.play("back_attack")
			$attack_time_out.start()
			
# Reset the player when starting a new game.
func start():
	animated_sprite.animation = "right"  # Set default animation
	animated_sprite.play()  # Start playing the animation
	position = start_position  # Reset position
	show()

func reset_player():
	position = start_position  # Reset the position to the start
	scale = original_scale # Reset the scale
	speed = 700  # Restore the speed
	hide()
	await get_tree().create_timer(0.5).timeout  # Small delay before showing
	show()

func _on_hit_box_body_entered(_body: Node2D) -> void:
	inside_hole = true

func _on_hit_box_body_exited(_body: Node2D) -> void:
	inside_hole = false

func fall():
	speed = 0
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.3)
	tween.finished.connect(self.reset_player)  # Connect the finished signal to reset_player
	tween.play()

func _on_attack_time_out_timeout() -> void:
	$attack_time_out.stop()
	is_attacking = false
	update_animations()

	
# Function to handle key collection
func collect_key(key_type):
	Keys.push_back(key_type) # Add to keys
	
# Handles collecting all types of keys by player
func _on_key_collected(KeyType: Variant) -> void:
	collect_key(KeyType)

# Once chest zone is entered, once can open it
func _on_chest_zone_entered(chest: Node2D) -> void:
	nearby_chest = chest  
  
# When player exits the chest zone
func _on_chest_zone_exited(s) -> void:
	nearby_chest = null    

func _process(delta):
	if inside_hole:
		fall()
		
	if nearby_chest and Input.is_action_just_pressed("ui_accept"):
		# Pass the reference to the chest
		emit_signal("openingChest", nearby_chest)
