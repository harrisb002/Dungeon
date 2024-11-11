extends Control

# Node Refs
@onready var panel = $CanvasLayer/Panel
@onready var dialog_speaker = $CanvasLayer/Panel/DialogBox/DialogSpeaker
@onready var dialog_text = $CanvasLayer/Panel/DialogBox/DialogText
@onready var dialog_options = $CanvasLayer/Panel/DialogBox/DialogOptions

func _ready():
	panel.visible = false

# Shows Dialog
func show_dialog(speaker, text, options):
	panel.visible = true
	
	#  Populating the data
	dialog_speaker.text = speaker
	dialog_text.text = text
	
	# Remove the existing options
	for child in dialog_options.get_children():
		dialog_options.remove_child(child)
	
	# Populating the options using response buttons
	for option in options.keys():
		# Creating a button with options
		var button = Button.new()
		button.text = option
		button.add_theme_font_size_override("font_size", 20)
		
		# Bind the button to the options selected function for event
		button.pressed.connect(_on_option_selected.bind(option))
		dialog_options.add_child(button)

# Hides Dialog
func hide_dialog():
	Global_Player.Player_node.can_move = true
	panel.visible = false

# Handle option selection
func _on_option_selected(option):
	pass
	#get_parent().handle_dialog_choice(option)

# Handle close button press (Skip the dialog branches)
func _on_close_button_pressed():
	hide_dialog()
