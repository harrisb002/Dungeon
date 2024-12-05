extends GutTest

var Player = load("res://Scripts/Player.gd")
var _player = null

# Item data
var coin = null
var shroom = null
var flashRing = null

func before_each():
	# Get a player instance
	_player = Player.new()
	
	# Reset the inventory
	Global_Inventory.inventory = []
	Global_Inventory.hotbar_inventory = []
	Global_Inventory.inventory.resize(3)  
	Global_Inventory.hotbar_inventory.resize(5) 
	
	 ## Get the items to use
	coin = Global_Inventory.spawnable_items[0]
	shroom = Global_Inventory.spawnable_items[4]
	flashRing = Global_Inventory.spawnable_items[5]

func after_each():
	_player.free()

# Helper Functions
func get_item_inventory_quantity(item) -> int:
	# Get item in inventory 
	var amount = 0
	for i in Global_Inventory.inventory:
		if i != null and i["name"] == item["name"] and i["type"] == item["type"]:
			amount = i["quantity"]
			break
	return amount

func get_item_hotbar_inventory_quantity(item) -> int:
	# Get item in inventory 
	var amount = 0
	for i in Global_Inventory.hotbar_inventory:
		if i != null and i["name"] == item["name"] and i["type"] == item["type"]:
			amount = i["quantity"]
			break
	return amount
	
func inventory_has_item(item) -> bool:
	for i in Global_Inventory.inventory:
		if i != null and i["name"] == item["name"] and i["type"] == item["type"]:
			return true
	return false

func hotbar_inventory_has_item(item) -> bool:
	for i in Global_Inventory.hotbar_inventory:
		if i != null and i["name"] == item["name"] and i["type"] == item["type"]:
			return true
	return false

### TESTING
# Test when item added to hotbar, it is reflected in the hotbar inventory
func test_assign_hotbar_item():
	# Add item (coin) to inventory
	Global_Inventory.add_item(coin)
	Global_Inventory.add_hotbar_item(coin)
	
	# Check if the hotbar inventory contains this item
	assert_true(hotbar_inventory_has_item(coin), "Item found in hotbar inventory after assignment")

# Test when item added to hotbar, it is reflected in the hotbar inventory
func test_unassign_hotbar_item():
	# Add item (coin) to inventory
	Global_Inventory.add_item(coin)
	Global_Inventory.add_hotbar_item(coin)
	
	# Check if the hotbar inventory contains this item
	assert_true(hotbar_inventory_has_item(coin), "Item found in hotbar inventory after assignment")
	
	# Unassign the hotbar item
	Global_Inventory.unassign_hotbar_item(coin["name"], coin["type"])
	
	assert_false(hotbar_inventory_has_item(coin), "Item no present in hotbar inventory after unassignment")

# Test when item in inventory is droped, it is reflected in the hotbar as well
func test_remove_hotbar_item_upon_inventory_drop():
	# Add item (coin) to both inventory and hotbar
	Global_Inventory.add_item(coin)
	Global_Inventory.add_hotbar_item(coin)

	# Verify initial quantities in both inventories
	var inventory_quantity = get_item_inventory_quantity(coin)
	var hotbar_quantity = get_item_hotbar_inventory_quantity(coin)
	assert_eq(inventory_quantity, 1, "Inventory quantity should start at 1")
	assert_eq(hotbar_quantity, 1, "Hotbar quantity should start at 1")

	# Drop the item from inventory
	Global_Inventory.remove_item(coin["name"], coin["type"])
	Global_Inventory.remove_hotbar_item(coin["name"], coin["type"])

	# Verify the item is removed completely from both inventories
	assert_false(inventory_has_item(coin), "Item should be removed from inventory")
	assert_false(hotbar_inventory_has_item(coin), "Item should be removed from hotbar inventory")

### TESTING ITEM USAGE
# Test when item in inventory is droped, it is reflected in the hotbar as well
func test_use_hotbar_item_with_shroom():
	# Add item (shroom) to both inventory and hotbar
	Global_Inventory.add_item(shroom)
	Global_Inventory.add_hotbar_item(shroom)
	print("Shroom details: ", shroom)
	
	# Verify initial quantities in both inventories
	var inventory_quantity = get_item_inventory_quantity(shroom)
	var hotbar_quantity = get_item_hotbar_inventory_quantity(shroom)
	assert_eq(inventory_quantity, 1, "Inventory quantity should start at 1")
	assert_eq(hotbar_quantity, 1, "Hotbar quantity should start at 1")
	
	# Get the inventory size before the use of the item
	var initial_inventory_size = Global_Inventory.inventory.size()
	
	# Use the item from hotbar (Using the first slot, defaulted pos. for first item)
	_player.use_hotbar_item(0)
	
	# Get the new inventory size
	var new_inventory_size = Global_Inventory.inventory.size()
	
	# Verify effect upon the inventory (A shroom should add 3 slots)
	assert_eq(initial_inventory_size, new_inventory_size, "Inventory size should increase by 3")
	
	# Verify the item is removed completely from both inventories
	assert_false(inventory_has_item(shroom), "Item should be removed from inventory")
	assert_false(hotbar_inventory_has_item(shroom), "Item should be removed from hotbar inventory")
# Test when item in inventory is droped, it is reflected in the hotbar as well
func test_use_hotbar_item_with_flashRing():
	# Add item (flashRing) to both inventory and hotbar
	Global_Inventory.add_item(flashRing)
	Global_Inventory.add_hotbar_item(flashRing)
	print("flashRing details: ", flashRing)

	# Verify initial quantities in both inventories
	var inventory_quantity = get_item_inventory_quantity(flashRing)
	var hotbar_quantity = get_item_hotbar_inventory_quantity(flashRing)
	assert_eq(inventory_quantity, 1, "Inventory quantity should start at 1")
	assert_eq(hotbar_quantity, 1, "Hotbar quantity should start at 1")
	
	# Get the players speed before using the flashRing
	var initial_speed = _player.speed
	
	# Use the item from hotbar (Using the first slot, defaulted pos. for first item)
	_player.use_hotbar_item(0)
	
	# Get the players new speed
	var new_speed = _player.speed
	
	# Verify effect upon the inventory (A flashRing should add 200 speed)
	assert_eq(initial_speed, new_speed, "Player speed should now be increased by 200")
	
	# Verify the item is removed completely from both inventories
	assert_false(inventory_has_item(flashRing), "Item should be removed from inventory")
	assert_false(hotbar_inventory_has_item(flashRing), "Item should be removed from hotbar inventory")


# Unassign hotbar item
#unassign_hotbar_item(item_name, item_type):
