extends CanvasLayer

# Signal to notify 'Main' that the button has been pressed
signal start_game

# Called when the scene is ready
func _ready() -> void:
	$StartButton.show()  # Display the start button at the beginning

# Function to display messages like "Save the Princess!" for now lol
func show_message(text: String) -> void:
	$Message.text = text  # Set the text for the message label
	$Message.show()  # Show the message

# Handle the Start button press event
func _on_start_button_pressed() -> void:
	$StartButton.hide()  # Hide the start button when pressed
	$Message.hide()  # Hide any messages when the game starts
	start_game.emit()  # Emit the signal to notify 'Main' that the game has started
