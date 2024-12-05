extends StaticBody2D

@onready var icon = $Icon
@onready var price = $Price
@onready var buyButton = $BuyButtonColor
var Inventory = Global_Inventory.Inventory_Script  
 
var shop_items = [
	{"id": "flash_ring", "type": "Attachment", "name": "FlashRing", "effect": "Increase Speed", "price": 100, "duration": 5, "texture": preload("res://allart/InventoryItems/increaseSpeed.png"), "scale": Vector2(2, 2)},
	{"id": "health_potion", "type": "Potion", "name": "HealthPotion", "effect": "+20 Health", "price": 100, "texture": preload("res://allart/InventoryItems/healthPotion.png"), "scale": Vector2(2, 2)},
	{"id": "shroom", "type": "Consumable", "name": "Shroom", "effect": "Increase Slots", "price": 100, "texture": preload("res://allart/InventoryItems/inventoryBoost.png"), "scale": Vector2(2, 2)},
	{"id": "map", "type": "Guide", "name": "Map", "effect": "Discovery", "price": 100, "texture": preload("res://allart/InventoryItems/map.png"), "scale": Vector2(2, 2)},
]

var item_idx = 0
var curr_item = shop_items[item_idx]

func _ready() -> void:
	icon.play(curr_item["name"]) 

func _physics_process(delta: float) -> void:
	if self.visible == true:
		icon.play(curr_item["name"])
		if Global_Player.coin_amount >= curr_item["price"]:
			buyButton.color = "00a07c22" # Green
		else:
			buyButton.color = "ff000022" # Red

func _on_button_left_pressed() -> void:
	swap_item_back()
	update_icon()
func _on_button_right_pressed() -> void:
	swap_item_forward()
	update_icon()
	
func _on_buy_button_pressed() -> void:
	# Get price of current item
	var item_price = curr_item["price"] 
	
	# See if player has enough coins
	if Global_Player.coin_amount >= item_price:
		buy(item_price)
	else:
		print("Not enough coins to buy %s!" % curr_item["name"])
		
func swap_item_back():
	if item_idx == 0:
		item_idx = shop_items.size() - 1
	else:
		item_idx -= 1
	curr_item = shop_items[item_idx]

func swap_item_forward():
	if item_idx < shop_items.size() - 1:
		item_idx += 1
	else:
		item_idx = 0
	curr_item = shop_items[item_idx]

func update_icon():
	icon.animation = curr_item["name"]

func buy(item_price):
	Global_Player.coin_amount -= item_price
	Global_Player.update_coins()
	print("Item purchased: %s for %d coins" % [curr_item["name"], item_price])
	
	Inventory.set_item_data(curr_item)
	Global_Inventory.add_item(curr_item)
