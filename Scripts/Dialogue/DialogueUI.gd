extends Control

# Node Refs
@onready var panel = $CanvasLayer/Panel
@onready var dialogue_speaker = $CanvasLayer/Panel/DialogueBox/DialogueSpeaker
@onready var dialogue_text = $CanvasLayer/Panel/DialogueBox/DialogueText
@onready var dialogue_options = $CanvasLayer/Panel/DialogueBox/DialogueOptions

func _ready():
	hide_dialogue()
	panel.visible = false

# Shows Dialog
func show_dialogue(speaker, text, options):
	panel.visible = true
	
	#  Populating the data
	dialogue_speaker.text = speaker
	dialogue_text.text = text
	
	# Remove the existing options
	for child in dialogue_options.get_children():
		dialogue_options.remove_child(child)
	
	# Populating the options using response buttons
	for option in options.keys():
		# Creating a button with options
		var button = Button.new()
		button.text = option
		button.add_theme_font_size_override("font_size", 20)
		
		# Bind the button to the options selected function for event
		button.pressed.connect(_on_option_selected.bind(option))
		dialogue_options.add_child(button)

# Hides Dialog
func hide_dialogue():
	# Allow the player to move again
	Global_Player.Player_node.can_move = true
	panel.visible = false

# Handle option selection
func _on_option_selected(option):
	get_parent().handle_dialogue_choice(option)

# Handle close button press (Skip the dialogue branches)
func _on_close_button_pressed():
	hide_dialogue()
