extends GutTest

# Scene refs
var player_scene = preload("res://Scenes/Player.tscn")

# Constants for item data
var coin_data = Global.spawnable_items[0]
var shroom_data = Global.spawnable_items[2]
var flashRing_data = Global.spawnable_items[3]

# Ran before each test
func setup():
	# Create Player Instance
	var player_instance = player_scene.instance()
	add_child(player_instance)
	Global.set_player_ref(player_instance)

	# Clear inventory
	Global.inventory = []

func test_pickup_item_updates_inventory():
	# Add item to inventory
	var added = Global.add_item(coin_data)

	# Assert the item was added successfully
	gut.p("Checking if item was added to inventory...")
	assert_true(added, "Successfully added an item to inventory")  # Ensure this assertion checks `true`

	# Check if the inventory contains this item
	var found = false
	for item in Global.inventory:
		if item != null and item["name"] == coin_data["name"] and item["type"] == coin_data["type"]:
			found = true
			break
	assert_true(found, "Item found in inventory after pickup")

# Test for correct stacking behavior in inventory
func test_item_stacking_updates_inventory():	
	Global.add_item(shroom_data)
	Global.add_item(shroom_data)
	
	# Get item in inventory 
	var got = 0
	for item in Global.inventory:
		if item != null and item["name"] == shroom_data["name"] and item["type"] == shroom_data["type"]:
			## Get the quantity of item in inventory
			got = item["quantity"]
			break

	assert_true(got == 2, "Item quantity should stack to 2")

# Test to make sure when one item is removed, it only decrements by 1
func test_item_decrementing_updates_inventory():	
	Global.add_item(shroom_data)
	Global.add_item(shroom_data)
	
	# Ensure quantity is 2
	var got = 0
	for item in Global.inventory:
		if item != null and item["name"] == shroom_data["name"] and item["type"] == shroom_data["type"]:
			got = item["quantity"]
			break
			
	assert_true(got == 2, "Item quantity should be 2 after adding twice")
	
	# Remove one of them
	Global.remove_item(shroom_data["name"], shroom_data["type"])

	# Check that quantity decreased by 1
	for item in Global.inventory:
		if item != null and item["name"] == shroom_data["name"] and item["type"] == shroom_data["type"]:
			got = item["quantity"]

	assert_true(got == 1, "Item quantity should be 1 after removing 1")
	
# Test for removing items from inventory
func test_item_removing_updates_inventory():
	gut.p("Adding item to inventory times")
	Global.add_item(coin_data)
	
	# Get item in inventory 
	var found = false
	for item in Global.inventory:
		if item != null and item["name"] == coin_data["name"] and item["type"] == coin_data["type"]:
			found = true
			break

	assert_true(found, "Item found in inventory after pickup")

	# Now remove the coin from inventory
	Global.remove_item(coin_data["name"], coin_data["type"])

	# Try to find the item in inventory again
	var removed = true
	for item in Global.inventory:
		if item != null and item["name"] == coin_data["name"] and item["type"] == coin_data["type"]:
			removed = false
			break

	assert_true(found, "Item successfully removed from inventory")

func cleanup():
	# Reset any global variables if necessary
	Global.inventory = []
	Global.hotbar_inventory = []
	if Global.Player_node:
		Global.Player_node.queue_free()  # Free the player instance after tests
	Global.Player_node = null  # Reset player reference
