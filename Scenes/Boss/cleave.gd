extends Area2D

@export var damage: int = 10  # Amount of damage to deal

var affected_bodies: Array = []

func _ready() -> void:
	# Connect signals programmatically using Callables
	self.connect("body_entered", Callable(self, "_on_body_entered"))
	self.connect("body_exited", Callable(self, "_on_body_exited"))

# Handle when a body enters the area
func _on_body_entered(body: Node) -> void:
	print(body)
	if body.is_in_group("player"):  # Check if the body is in the 'player' group
		affected_bodies.append(body)

# Handle when a body exits the area
func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		affected_bodies.erase(body)

# Apply damage to all affected bodies
func apply_damage() -> void:
	for body in affected_bodies:
		if body.has_method("take_damage"):
			body.take_damage(damage)  # Call a damage method on the player or target
