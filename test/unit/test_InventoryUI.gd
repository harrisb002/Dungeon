extends GutTest

# Item data
var coin = null

func before_each():
	Global.inventory = []
	Global.inventory.resize(9)  # Reset the inventory to its initial size 
	coin = Global.spawnable_items[0]

# Helper Functions
func get_item_quantity(item) -> int:
	# Get item in inventory 
	var amount = 0
	for i in Global.inventory:
		if i != null and i["name"] == item["name"] and i["type"] == item["type"]:
			amount = i["quantity"]
			break
	return amount
func inventory_has_item(item) -> bool:
	for i in Global.inventory:
		if i != null and i["name"] == item["name"] and i["type"] == item["type"]:
			return true
	return false

# Test that when an item is added then it is reflected in the inventory
func test_pickup_item():
	# Add item (coin) to inventory
	var added = Global.add_item(coin)
	assert_true(added, "Successfully added an item to inventory")
	
	# Check if the inventory contains this item
	assert_true(inventory_has_item(coin), "Item found in inventory after pickup")

# Test for correct stacking behavior in inventory
func test_item_stacking():	
	Global.add_item(coin)
	Global.add_item(coin)

	# Get item in inventory 
	var amount = get_item_quantity(coin)	
	assert_true(amount == 2, "Item quantity should stack to 2")

# Test that when an item is removed then it is reflected in the inventory
func test_item_decrement():	
	Global.add_item(coin)
	Global.add_item(coin)

	# Get item in inventory 
	var amount = get_item_quantity(coin)
	assert_true(amount == 2, "Item quantity should be 2")
	
	# Now remove one coin from inventory
	Global.remove_item(coin["name"], coin["type"])
	
	# Get item in inventory 
	amount = get_item_quantity(coin)
	assert_true(amount == 1, "Item quantity should now be 1")

# Test when item reaches 0 it is remved from inventory entirely
func test_item_removal_upon_zero():
	Global.add_item(coin)
	# Check if the inventory contains this item
	assert_true(inventory_has_item(coin), "Item found in inventory")
	Global.remove_item(coin["name"], coin["type"])
	assert_false(inventory_has_item(coin), "Item not found in inventory")
