extends CharacterBody2D

# Defines a custom signal called “hit” that we will have 
#  our player emit (send out) when it collides with an enemy
#signal hit

@export var speed = 800  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.
var can_move = false  # Flag to allow movement only after the game starts
var inside_hole = false # Flag for falling in holes
var start_position = Vector2.ZERO  # Variable to store the player's starting position
var original_scale = Vector2.ONE  # Variable to store the player's original scale

# Run as soon as the object/scene is ready in the game, done before everything else
func _ready():
	screen_size = get_viewport_rect().size
	original_scale = scale  # Store the player's original scale
	start_position = position  # Store the player's start position
	hide() # Hide the player at the start of the game

# Detect whether a key is pressed using Input.is_action_pressed(),
#   which returns true if it is pressed or false if it isn’t.
func _physics_process(delta: float) -> void:
	if not can_move:
		return  # Check if allowed to move 
		
	if inside_hole:
		fall()
		
	# Start by setting the velocity to (0, 0)- player should not be moving
	var velocity = Vector2()  # The player's movement vector.

	# is_action_pressed is a function that maps to the key 
	#   (This has been set in Project Settings => Input Map)
	if Input.is_action_pressed("move_right"):
		velocity.x += 3
	if Input.is_action_pressed("move_left"):
		velocity.x -= 3
		
	# Top Left of the screen is the Orgin! Thus 'y' gets bigger going down
	if Input.is_action_pressed("move_down"):
		velocity.y += 3
	if Input.is_action_pressed("move_up"):
		velocity.y -= 3
	
	if velocity.length() > 0:
	# Normalize the velocity, which means we set its length to 1,
	#   and multiply by the desired speed, thus no more fast diagonal movement.
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

# Change which animation the AnimatedSprite is playing based on direction
	if velocity.x !=0:
		$AnimatedSprite2D.animation = "walk"
# “walk” animation, which should be flipped horz. using the flip_h for left movement,
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
#“up” animation, which should be flipped vertically with flip_v for down movement
		$AnimatedSprite2D.animation = "walk" # Using both for same animation
		
	# Move the player
	position += velocity * delta
	move_and_slide()

# Reset the player when starting a new game.
func start():
	can_move = true  # Allow movement now that the game has started
	$AnimatedSprite2D.animation = "walk"  # Set default animation
	$AnimatedSprite2D.play()  # Start playing the animation
	position = start_position  # Reset position
	show()


func _on_hit_box_body_entered(body: Node2D) -> void:
	inside_hole = true

func _on_hit_box_body_exited(body: Node2D) -> void:
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
