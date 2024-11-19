extends GutTest

# Refs
var Player = load("res://Scripts/Player.gd")
var Chest = load("res://Scripts/Chest.gd")
 
var _player = null
var _chest = null

func before_each():
	_player = Player.new()
	_chest = Chest.new()

	# Add mock `open` and `closed` nodes to `_chest`
	var open_node = Sprite2D.new()
	open_node.name = "open"
	open_node.visible = false  
	_chest.add_child(open_node)

	var closed_node = Sprite2D.new()
	closed_node.name = "closed"
	closed_node.visible = true  
	_chest.add_child(closed_node)
	
	Global_Inventory.inventory = []
	Global_Inventory.inventory.resize(9)
	
func after_each():
	_player.free()
	_chest.free()

### TESTING

# Test opening a Common chest with a Common key
func test_open_common_chest_with_common_key():
	# Add a Common key to the inventory
	var common_key = {"name": "Key", "type": "Common", "quantity": 1}
	Global_Inventory.add_item(common_key)
	
	# Set the chest type to COMMON and attempt to open it
	_chest.chest_type = Chest.ChestType.COMMON
	_chest.open_chest(_chest, _chest.chest_type)
	
	# Check if the chest is open and key is used
	assert_true(_chest.get_node("open").visible, "Common chest opened with a Common key.")
	assert_false(Global_Inventory.has_key_in_inventory("Key", "Common"), "Common key was removed from inventory after use.")

# Test opening a Golden chest with a Golden key
func test_open_golden_chest_with_golden_key():
	# Add a Golden key to the inventory
	var golden_key = {"name": "Key", "type": "Golden", "quantity": 1}
	Global_Inventory.add_item(golden_key)
	
	# Set the chest type to GOLDEN and attempt to open it
	_chest.chest_type = Chest.ChestType.GOLDEN
	_chest.open_chest(_chest, _chest.chest_type)
	
	# Check if the chest is open and key is used
	assert_true(_chest.get_node("open").visible, "Golden chest opened with a Golden key.")
	assert_false(Global_Inventory.has_key_in_inventory("Key", "Golden"), "Golden key was removed from inventory after use.")

# Test opening a Boss chest with a Boss key
func test_open_boss_chest_with_boss_key():
	# Add a Boss key to the inventory
	var boss_key = {"name": "Key", "type": "Boss", "quantity": 1}
	Global_Inventory.add_item(boss_key)
	
	# Set the chest type to BOSS and attempt to open it
	_chest.chest_type = Chest.ChestType.BOSS
	_chest.open_chest(_chest, _chest.chest_type)
	
	# Check if the chest is open and key is used
	assert_true(_chest.get_node("open").visible, "Boss chest did not open with a Boss key.")
	assert_false(Global_Inventory.has_key_in_inventory("Key", "Boss"), "Boss key was not removed from inventory after use.")

# Test opening a chest without the correct key
func test_open_chest_without_key():
		# Set the chest type to Common and attempt to open it
	_chest.chest_type = Chest.ChestType.COMMON
	_chest.open_chest(_chest, _chest.chest_type)
	
	# Check that the chest is still closed
	assert_false(_chest.get_node("open").visible, "Common chest did not open without a Common key.")
	
	# Set the chest type to GOLDEN and attempt to open it
	_chest.chest_type = Chest.ChestType.GOLDEN
	_chest.open_chest(_chest, _chest.chest_type)
	
	# Check that the chest is still closed
	assert_false(_chest.get_node("open").visible, "Golden chest did not open without a Golden key.")
	
	# Set the chest type to BOSS and attempt to open it without a Boss key
	_chest.chest_type = Chest.ChestType.BOSS
	_chest.open_chest(_chest, _chest.chest_type)
	
	# Check that the chest is still closed
	assert_false(_chest.get_node("open").visible, "Boss chest opened without a Boss key.")
