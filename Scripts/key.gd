extends StaticBody2D

# Keys to open different chests
enum KeyType { COMMON, GOLDEN, BOSS }

# Default key type (Can set in Inspector)
@export var key_type = KeyType.COMMON  

# Signal to determine key type
signal collected(KeyType)

# To remove key if picked up
var keyTaken= false

func _on_area_2d_body_entered(body: PhysicsBody2D) -> void:
	if keyTaken == false:
		keyTaken = true
		# Pass the key with the signal to Player
		emit_signal("collected", key_type) 
		$Sprite2D.queue_free()
