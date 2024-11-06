extends GutTest

var Player = load("res://Scripts/Player.gd")
var _player = null

func before_each():
	# Create a new player instance
	_player = Player.new()
	_player.start_position = Vector2(0, 0)  # Set an arbitrary start position
	_player.original_scale = Vector2(1, 1)  # Set the player's original scale
	_player._ready()  # Initialize the player

func after_each():
	_player.free()

### TESTING
func test_player_fall():
	# MAke the players pos. be different than start
	_player.start_position = Vector2(25, 25)
	
	# Simulate collision with a hole
	_player._on_hit_box_body_entered(null)
	
	# Run the process to trigger the fall behavior
	_player._process(0)  # delta time is set to 0 for simplicity
	
	# Assert that the player is falling (inside_hole flag is true)
	assert_true(_player.inside_hole, "Player correctly detected being inside the hole.")
	
	# Wait for the timer to complete in reset_player
	await _player.reset_player()
	
	# Check if the player has reset correctly
	assert_eq(_player.position, _player.start_position, "Player did not reset to start position after falling.")
	assert_eq(_player.scale, _player.original_scale, "Player did not reset scale after falling.")
	assert_eq(_player.speed, 1000, "Player speed is default after falling.")
