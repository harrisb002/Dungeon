extends Area2D

var velocity : Vector2
@export var lifetime : float = 3.0
#TODO: change mask to hit detected enemies

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity * delta


func _on_timer_timeout() -> void:
	queue_free()
	


func _on_body_entered(body: Node2D) -> void:
	#TODO: do damage here make sure that the body is an 
	body.take_damage(5)
	queue_free()
