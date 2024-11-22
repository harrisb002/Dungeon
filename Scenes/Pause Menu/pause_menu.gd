#extends Control
#
#
## Called when the node enters the scene tree for the first time.
##func _ready():
	##$AnimationPlayer.play("RESET")
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#test_Escape()
#
##func resume():
	##
	##print("Message")
	##get_tree().paused = false;
	##$AnimationPlayer.play_backwards("blur")
	##
##func pause():
	##
	##print("Message")
	##get_tree().paused = true;
	##$AnimationPlayer.play("blur")
#
##func pause():
	##print("Pause function called")
	##get_tree().paused = true
	##print("Tree paused state:", get_tree().paused)
	##$AnimationPlayer.play("blur")
	##print("Tried to play blur animation")
	##
##func resume():
	##print("Resume function called")
	##get_tree().paused = false
	##print("Tree paused state:", get_tree().paused)
	##$AnimationPlayer.play_backwards("blur")
	##print("Tried to play reverse blur animation")
	#
## At the start of your script
#func _ready():
	#$AnimationPlayer.play("RESET")
	## Make sure the menu starts invisible
	#visible = false
#
#func pause():
	#get_tree().paused = true
	## Make the menu visible before playing animation
	#visible = true
	#$AnimationPlayer.play("blur")
	#
#func resume():
	#get_tree().paused = false
	#$AnimationPlayer.play_backwards("blur")
	## You might want to hide the menu after animation finishes
	## Connect to animation_finished signal to do this
	#
#func test_Escape():
	#if Input.is_action_just_pressed("pause_menu"):
		#print("Pause key pressed!")
		#if get_tree().paused == false:
			#print("Attempting to pause")
			#pause()
		#else:
			#print("Attempting to resume")
			#resume()
#
#func _on_resume_button_pressed():
	#resume() 
#
#
#func _on_quit_button_pressed():
	#get_tree().quit()
#
#
#func _on_restart_button_pressed():
	#
	#resume() 
	#get_tree().reload_current_scene() 
extends Control

func _ready():
	# Make sure menu starts hidden
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
	if Input.is_action_just_pressed("pause_menu"):
		if !get_tree().paused:
			pause()
		else:
			resume()

func pause():
	print("Pausing...")
	get_tree().paused = true
	# Show menu before animation
	show()
	$AnimationPlayer.play("blur")
	print("Menu visibility:", visible)
	
func resume():
	print("Resuming...")
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	await $AnimationPlayer.animation_finished
	hide()

func _on_resume_button_pressed():
	resume()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_restart_button_pressed():
	resume()
	get_tree().reload_current_scene()
