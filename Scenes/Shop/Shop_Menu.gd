extends StaticBody2D

@onready var icon = $Icon

var items = [
	{"id": "FlashRing", "quantity": 0, "type": "Attachment", "name": "Flash Ring", "effect": "Increase Speed", "duration": 5, "texture": preload("res://allart/InventoryItems/increaseSpeed.png"), "scale": Vector2(2, 2)},
	{"id": "HealthPotion", "quantity": 0, "type": "Potion", "name": "Health Potion", "effect": "+20 Health", "texture": preload("res://allart/InventoryItems/healthPotion.png"), "scale": Vector2(2, 2)},
	{"id": "Shroom", "quantity": 0, "type": "Consumable", "name": "Shroom", "effect": "Increase Slots", "texture": preload("res://allart/InventoryItems/inventoryBoost.png"), "scale": Vector2(2, 2)},
	{"id": "Map", "quantity": 0, "type": "Guide", "name": "Dungeon Map", "effect": "Discovery", "texture": preload("res://allart/InventoryItems/map.png"), "scale": Vector2(2, 2)},
]

var item_idx = 0
var curr_item = items[item_idx]

func _ready() -> void:
	icon.play(curr_item["id"]) 

func _physics_process(delta: float) -> void:
	if self.visible == true:
		icon.play(curr_item["id"])

func _on_button_left_pressed() -> void:
	swap_item_back()
	update_icon()
func _on_button_right_pressed() -> void:
	swap_item_forward()
	update_icon()
func _on_buy_button_pressed() -> void:
	print("Buy Button clicked") 

func swap_item_back():
	if item_idx == 0:
		item_idx = items.size() - 1
	else:
		item_idx -= 1
	curr_item = items[item_idx]

func swap_item_forward():
	if item_idx < items.size() - 1:
		item_idx += 1
	else:
		item_idx = 0
	curr_item = items[item_idx]

func update_icon():
	icon.animation = curr_item["id"]
