extends CharacterBody2D

@export var speed = 1000 

@onready var animated_sprite = $AnimatedSprite2D

# Inventory vars
@onready var interact_ui = $InteractUI
@onready var interact_ui_label = $InteractUI/ColorRect/Label
@onready var inventory_ui = $InventoryUI
@onready var inventory_hotbar = $InventoryHotbar/Inventory_Hotbar

# Quest vars
@onready var quest_manager_node = $Quest_Manager
@onready var objectives_node = $HUD/QuestTracker/Details/Objectives
@onready var quest_tracker_node = $HUD/QuestTracker
@onready var amount_node = $HUD/Coins/Amount
@onready var title_node = $HUD/QuestTracker/Details/Title

# Coin vars
@onready var coin_icon = $HUD/Coins/Icon
# Quest vars
@onready var ray_cast = $RayCast2D

var interact_ui_raycast_visible = false  # Flag to track if UI is shown due to RayCast

# Player positioning
var screen_size  # Size of the game window.
var start_position = Vector2.ZERO  # Variable to store the player's starting position
var original_scale = Vector2.ONE  # Variable to store the player's original scale
var inside_hole = false # Flag for falling in holes

# Attack/animation vars
var curr_direction = "move_right" # Check what side we are currenlty moving 
var is_attacking = false  # Check if attack frames are on

# Changes the animation based on selection of player
var animation_prefix = Global_Player.character + "_"

# QuestUI/Interactions vars
var can_move = true # Used to prevent player movement while interacting with NPC

# Reset the player when starting a new game.
func start():
	animated_sprite.animation = (animation_prefix + "right")  # Set default animation
	animated_sprite.play()  # Start playing the animation
	position = start_position  # Reset position
	show()

# Run as soon as the object/scene is ready in the game, done before everything else
func _ready():
	# Set the Player reference instance to access the player globally
	Global_Player.set_player_ref(self)
	
	# Sets nodes related to quest management interactions
	Global_Player.set_quest_node_refs(quest_manager_node, quest_tracker_node, title_node, objectives_node, amount_node)
	
	# Set inventory hotbar to be accessible globally
	Global_Player.set_inventory_hotbar(inventory_hotbar)
	
	# Make the Quest tracker hidden until opened
	Global_Player.quest_tracker.visible = false 
	Global_Player.update_coins()
	
	# Signal connections for Quest managment
	Global_Player.quest_manager.quest_updated.connect(Global_Player._on_quest_updated)
	Global_Player.quest_manager.objective_updated.connect(Global_Player._on_objective_updated)
	
	screen_size = get_viewport_rect().size
	original_scale = scale  # Store the player's original scale
	start_position = position  # Store the player's start position
	hide() # Hide the player at the start of the game

# Detect whether a key is pressed using Input.is_action_pressed(),
#   which returns true if it is pressed or false if it isn’t.
func _physics_process(delta):
	# Disable movement while interacting with NPC
	if can_move: 
		get_input()
		move_and_slide()
		update_animations()
		attack()
	update_interact_ui()  # Update interact UI for NPC detection

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed

	# Turn the raycast in the direction of players movement
	if velocity != Vector2.ZERO:
		ray_cast.target_position = velocity.normalized() * 50 # Length of cast

func _input(event):
	if event.is_action_pressed("inventory"):
		# Create a toggle switch
		inventory_ui.visible = !inventory_ui.visible
		# Pause the game, on/off
		get_tree().paused = !get_tree().paused
	
	if can_move:
		# Checking for interactions with NPC 
		if event.is_action_pressed("interact"):
			var target = ray_cast.get_collider()
			
			if target != null and target.is_in_group("NPC"):
				interact_ui.visible = false
				can_move = false  # Disable movement while interacting
				Global_Player.inventory_hotbar.visible = false
				Global_Player.check_quest_objectives(target.npc_id, "talk_to")
				target.start_dialogue()
				
		# Opening the QuestUI
		if event.is_action_pressed("quest_menu"):
			Global_Player.quest_manager.show_hide_log()

func _process(delta):
	if inside_hole:
		fall()

# Update the interaction label based on RayCast collision for NPCs
func update_interact_ui():
	var target = ray_cast.get_collider()
	if target != null and target.is_in_group("NPC"):
		interact_ui_label.text = "Press E to interact"
		if not interact_ui.visible:
			interact_ui.visible = true
		interact_ui_raycast_visible = true  # Set the flag to true
	else:
		if interact_ui_raycast_visible:
			# Only hide if we were showing it due to RayCast
			interact_ui.visible = false
			interact_ui_raycast_visible = false  # Reset the flag

func update_animations():
	var animation = ""
	#var animation_prefix = Global.character + "_"
	#var animation_prefix = "knight_"
	if is_attacking:
		return  
	if inside_hole:
		fall()
		
	if velocity == Vector2.ZERO:
		animated_sprite.stop()
	else:
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				animation = "right"
				curr_direction = "move_right"
			else:
				animation = "left"
				curr_direction = "move_left"
		else:
			if velocity.y > 0:
				animation = "backward"
				curr_direction = "move_down"
			else:
				animation = "forward"
				curr_direction = "move_up"
		animated_sprite.play(animation_prefix + animation)

func attack():
	if Input.is_action_just_pressed("attack") and not is_attacking:
		var animation = ""
		#var animation_prefix = Global.character + "_"
		is_attacking = true  # Set the flag to true
		if(curr_direction == "move_right") :
			animation = "right_attack"		
		elif(curr_direction == "move_left") :
			animation = "left_attack"
		elif(curr_direction == "move_down"):
			animation = "back_attack"
		elif(curr_direction == "move_up"):
			animation = "forward_attack"
		$attack_time_out.start()
		animated_sprite.play(animation_prefix + animation)
		if animation_prefix == "mage_":
			mage_attack()
			
func mage_attack():
	var projectile_scene = preload("res://Scenes/Player/mage_projectile.tscn")
	var projectile = projectile_scene.instantiate()
	
	projectile.position = position
	var direction = Vector2.ZERO
	#direction of attack and rotation 
	match curr_direction:
		"move_right":
			direction = Vector2.RIGHT
		"move_left":
			direction = Vector2.LEFT
			projectile.rotation_degrees = 180
		"move_down":
			direction = Vector2.DOWN
			projectile.rotation_degrees = 90
		"move_up":
			direction = Vector2.UP
			projectile.rotation_degrees = 270
	
	projectile.velocity = direction * 800
	get_tree().current_scene.add_child(projectile)

# Hotbar Shorcut usage
func _unhandled_input(event: InputEvent):
	if event is InputEventKey and event.pressed:
		## Loop through the hotbar slots
		for i in range(Global_Inventory.hotbar_size):
			## Check if a specific key is pressed
			if Input.is_action_just_pressed("hotbar_" + str(i + 1)):
				use_hotbar_item(i)
				break

# Hotbar Shortcuts
func use_hotbar_item(slot_idx):
	if slot_idx < Global_Inventory.hotbar_inventory.size():
		var item = Global_Inventory.hotbar_inventory[slot_idx]
		if item != null:
			## Use the item in this slot
			apply_item_effect(item)
			## Remove the item
			item["quantity"] -= 1
			if item["quantity"] <= 0:
				Global_Inventory.hotbar_inventory[slot_idx] = null
				## Decrease the quantity in the main inventory
				Global_Inventory.remove_item(item["name"], item["type"])
			## Emit signal to update the inventory as well
			Global_Inventory.inventory_updated.emit()

# Apply effect of the item (if it has one)
func apply_item_effect(item):
	match item["effect"]:
		"Increase Speed":
			speed += 200
		"Increase Slots":
			Global_Inventory.increase_inventory_size(6)
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
		# Only create the timer if get_tree() is valid
	if get_tree():
		await get_tree().create_timer(0.5).timeout  # Small delay before showing
	show()

func _on_hit_box_body_entered(_body: Node2D):
	inside_hole = true

func _on_hit_box_body_exited(_body: Node2D):
	inside_hole = false
