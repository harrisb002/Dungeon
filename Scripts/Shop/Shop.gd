extends StaticBody2D

@onready var shopMenu = $ShopMenu 

func _ready() -> void:
	shopMenu.visible = false
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	# Check if has function
	#if body.has_method("player_shop"):
	shopMenu.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	shopMenu.visible = false
