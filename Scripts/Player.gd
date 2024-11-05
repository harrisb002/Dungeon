extends CharacterBody2D

@export var speed = 1000  

@onready var animated_sprite = $AnimatedSprite2D
@onready var interact_ui = $InteractUI
@onready var inventory_ui = $InventoryUI
@onready var inventory_ui_label = $InteractUI/ColorRect/Label
@onready var inventory_hotbar = $InventoryHotbar/Inventory_Hotbar

var screen_size  # Size of the game window.
var start_position = Vector2.ZERO  # Variable to store the player's starting position
var original_scale = Vector2.ONE  # Variable to store the player's original scale
var inside_hole = false # Flag for falling in holes

var curr_direction = "move_right" # Check what side we are currenlty moving 
var is_attacking = false  # Check if attack frames are on

# Reset the player when starting a new game.
func start():
	animated_sprite.animation = "right"  # Set default animation
	animated_sprite.play()  # Start playing the animation
	position = start_position  # Reset position
	show()

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
func _physics_process(delta):
	get_input()
	move_and_slide()
	update_animations()
	attack()

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed

func _input(event):
	if event.is_action_pressed("inventory"):
		# Create a toggle switch
		inventory_ui.visible = !inventory_ui.visible
		
		# Pause the game, on/off
		get_tree().paused = !get_tree().paused
		
		# Hide the hotbar when the inventory is open
		inventory_hotbar.visible = !inventory_hotbar.visible

func _process(delta):
	if inside_hole:
		fall()

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

# Hotbar Shorcut usage
func _unhandled_input(event: InputEvent):
	if event is InputEventKey and event.pressed:
		## Loop through the hotbar slots
		for i in range(Global.hotbar_size):
			## Check if a specific key is pressed
			if Input.is_action_just_pressed("hotbar_" + str(i + 1)):
				use_hotbar_item(i)
				break

# Hotbar Shortcuts
func use_hotbar_item(slot_idx):
	if slot_idx < Global.hotbar_inventory.size():
		var item = Global.hotbar_inventory[slot_idx]
		if item != null:
			## Use the item in this slot
			apply_item_effect(item)
			## Remove the item
			item["quantity"] -= 1
			if item["quantity"] <= 0:
				Global.hotbar_inventory[slot_idx] = null
				## Decrease the quantity in the main inventory
				Global.remove_item(item["name"], item["type"])
			## Emit signal to update the inventory as well
			Global.inventory_updated.emit()

# Apply effect of the item (if it has one)
func apply_item_effect(item):
	match item["effect"]:
		"Increase Speed":
			speed += 200
			print("Speed increased to ", speed)
		"Increase Slots":
			Global.increase_inventory_size(6)
			print("Slots increased to ", Global.inventory.size())
		_:
			print("No effect exists for this item")

func _on_attack_time_out_timeout():
	$attack_time_out.stop()
	is_attacking = false
	update_animations()

func fall():
	speed = 0
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.3)
	tween.finished.connect(self.reset_player)  # Connect the finished signal to reset_player
	tween.play()

func reset_player():
	position = start_position  # Reset the position to the start
	scale = original_scale # Reset the scale
	speed = 1000  # Restore the speed
	hide()
	await get_tree().create_timer(0.5).timeout  # Small delay before showing
	show()

func _on_hit_box_body_entered(_body: Node2D):
	inside_hole = true

func _on_hit_box_body_exited(_body: Node2D):
	inside_hole = false
