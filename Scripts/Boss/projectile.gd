extends Area2D
@export var speed: float = 500.0
@export var proj_life_timer: float = 3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#destroy self after timer
	await get_tree().create_timer(proj_life_timer).timeout
	queue_free()


func _process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): 
		body.take_damage(10)
	#do dmage to player here
	queue_free()
