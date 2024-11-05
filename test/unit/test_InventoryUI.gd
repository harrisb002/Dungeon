extends GutTest

# Constants for item data
var item_data = {"quantity": 1, "type": "Money", "name": "Coin", "effect": "", "texture": preload("res://allart/InventoryItems/coin.png")}

func setup():
	# Initialize Global inventory and clear any previous entries
	Global.inventory = []
	Global.hotbar_inventory = []

func test_pickup_item_updates_inventory():
	# Step 1: Add item to inventory
	print("Adding item to inventory...")
	var added = Global.add_item(item_data)
	
	# Step 2: Assert the item was added successfully
	print("Checking if item was added to inventory...")
	assert_true(added, "Failed to add item to inventory")  # Ensure this assertion checks `true`

	# Step 3: Check if the inventory contains this item
	var found = false
	for i in Global.inventory:
		if i != null and i["name"] == item_data["name"] and i["type"] == item_data["type"]:
			found = true
			print("Item found in inventory")
			break
	assert_true(found, "Item not found in inventory after pickup")
