extends "res://Scripts/mobmovement.gd"

var health = 0
@export var max_hp = 20
var min_hp = 0
var is_dead = false

func _ready():
	health = max_hp
	speed = 200 
   
func take_damage(dmg: int) -> void:
	if not is_dead:
		health -= dmg
		#print(boss_hp)
		if health <= 0:
				#speed = 0
				die()
				
func die():
	if is_dead:
		return
	else:	
		queue_free()
