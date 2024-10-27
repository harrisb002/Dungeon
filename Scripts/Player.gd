extends CharacterBody2D

# Send signal to try to open chest
signal openingChest

# Defines a custom signal called “hit” that we will have 
#  our player emit (send out) when it collides with an enemy
#signal hit

@export var speed = 700  # How fast the player will move (pixels/sec).

var screen_size  # Size of the game window.
var can_move = false  # Flag to allow movement only after the game starts
var inside_hole = false # Flag for falling in holes
var start_position = Vector2.ZERO  # Variable to store the player's starting position
var original_scale = Vector2.ONE  # Variable to store the player's original scale
var curr_direction = "move_right" # Check what side we are currenlty moving 
var is_attacking = false  # Check if attack frames are on

var Keys = [] # Contains all collected keys

# Store specific chest the player is near
var nearby_chest = null  

# Run as soon as the object/scene is ready in the game, done before everything else
func _ready():
	screen_size = get_viewport_rect().size
	original_scale = scale  # Store the player's original scale
	start_position = position  # Store the player's start position
	hide() # Hide the player at the start of the game
	
# Detect whether a key is pressed using Input.is_action_pressed(),
#   which returns true if it is pressed or false if it isn’t.
func _physics_process(delta: float) -> void:
	if not can_move or is_attacking: ## locks user from doing other frames if attack is currently happing
		return  # Check if allowed to move 
		
	if inside_hole:
		fall()
	
	# Start by setting the local_velocity to (0, 0)- player should not be moving
	var local_velocity = Vector2()  # The player's movement vector.
	
	# is_action_pressed is a function that maps to the key 
	#   (This has been set in Project Settings => Input Map)
	if Input.is_action_pressed("move_right"):
		curr_direction = "move_right"
		local_velocity.x += 3
	if Input.is_action_pressed("move_left"):
		curr_direction = "move_left"
		local_velocity.x -= 3
		
	# Top Left of the screen is the Orgin! Thus 'y' gets bigger going down
	if Input.is_action_pressed("move_down"):
		curr_direction = "move_down"
		local_velocity.y += 3
	if Input.is_action_pressed("move_up"):
		curr_direction = "move_up"
		local_velocity.y -= 3
	
	if local_velocity.length() > 0:
	# Normalize the local_velocity, which means we set its length to 1,
	#   and multiply by the desired speed, thus no more fast diagonal movement.
		local_velocity = local_velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

# Change which animation the AnimatedSprite is playing based on direction
	if local_velocity.x !=0:
		$AnimatedSprite2D.animation = "right"
# “walk” animation, which should be flipped horz. using the flip_h for left movement,
		$AnimatedSprite2D.flip_h = local_velocity.x < 0
	elif local_velocity.y != 0:
#“up” animation, which should be flipped vertically with flip_v for down movement
		if Input.is_action_pressed("move_up"):#checks what animation to add depending if key is going up or down
			$AnimatedSprite2D.animation = "backward" #sets the backwards movment
		else:
			$AnimatedSprite2D.animation = "forward"#sets forward movment
			
		
	
	# Move the player
	
	position += local_velocity * delta
	
	
	move_and_slide()
	attack()
	
	
func attack():
	# does the same thing as movment expect has a timer to check when animation is done
	
	if Input.is_action_just_pressed("attack"):
		is_attacking = true  # Set the flag to true
		if(curr_direction == "move_right"):
			$AnimatedSprite2D.flip_h =false## setting timer to true that way we know not to allow user to hit any other frames
			$AnimatedSpsrite2D.play("side_attack")
			$attack_time_out.start()
		if(curr_direction == "move_left"):
			$AnimatedSprite2D.flip_h =true
			$AnimatedSprite2D.play("side_attack")
			$attack_time_out.start()
			
		if(curr_direction == "move_down"):
			$AnimatedSprite2D.play("forward_attack")
			$attack_time_out.start()
		if(curr_direction == "move_up"):
			$AnimatedSprite2D.play("back_attack")
			$attack_time_out.start()
			
	
	

# Reset the player when starting a new game.
func start():
	can_move = true  # Allow movement now that the game has started
	$AnimatedSprite2D.animation = "right"  # Set default animation
	$AnimatedSprite2D.play()  # Start playing the animation
	position = start_position  # Reset position
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
	
func reset_player():
	position = start_position  # Reset the position to the start
	scale = original_scale # Reset the scale
	speed = 800  # Restore the speed
	hide()
	await get_tree().create_timer(0.5).timeout  # Small delay before showing
	show()

func _on_attack_time_out_timeout() -> void:
	$attack_time_out.stop()
	is_attacking =false
	
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
func _on_chest_zone_exited() -> void:
	nearby_chest = null    


func _process(delta):
	if inside_hole:
		fall()
		
	if nearby_chest and Input.is_action_just_pressed("ui_accept"):
		# Pass the reference to the chest
		emit_signal("openingChest", nearby_chest)
