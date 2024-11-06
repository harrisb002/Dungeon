# extends GutTest

# # Test that adding items correctly updates the hotbar assignment
# func test_hotbar_assignment_unassignment():
#     # Add item to hotbar
#     var added_to_hotbar = Global.add_item(speed_boost_data, true)
#     assert_true(added_to_hotbar, "Failed to assign item to hotbar")

#     # Verify item is in hotbar
#     assert_true(Global.is_item_assigned_to_hotbar(speed_boost_data), "Item should be assigned to hotbar")

#     # Unassign item from hotbar
#     var unassigned = Global.unassign_hotbar_item(speed_boost_data["name"], speed_boost_data["type"])
#     assert_true(unassigned, "Failed to unassign item from hotbar")
#     assert_false(Global.is_item_assigned_to_hotbar(speed_boost_data), "Item should no longer be assigned to hotbar")

# Test hotbar shortcut to apply item effects
# func test_hotbar_shortcut_usage():
#     # Add an item to the hotbar
#     Global.add_hotbar_item(speed_boost_data)
	
#     # Simulate using a hotbar shortcut
#     Global.Player_node.use_hotbar_item(0)
#     assert_true(Global.Player_node.speed > 1000, "Player speed should increase after using hotbar shortcut for Flash Ring")


# Test that adding items correctly updates the hotbar assignment
#func test_hotbar_assignment_unassignment():
	## Add item to hotbar
	#var added_to_hotbar = Global.add_item(speed_boost_data, true)
	#assert_true(added_to_hotbar, "Failed to assign item to hotbar")
#
	## Verify item is in hotbar
	#assert_true(Global.is_item_assigned_to_hotbar(speed_boost_data), "Item should be assigned to hotbar")
#
	## Unassign item from hotbar
	#var unassigned = Global.unassign_hotbar_item(speed_boost_data["name"], speed_boost_data["type"])
	#assert_true(unassigned, "Failed to unassign item from hotbar")
	#assert_false(Global.is_item_assigned_to_hotbar(speed_boost_data), "Item should no longer be assigned to hotbar")
