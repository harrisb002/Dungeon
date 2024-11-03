extends Node
class_name ItemMapping

# Create a mapping dictionary to map each index to its corresponding item name
var mapping = {}

# Function to initialize the mapping, this is defined in the Global
# this matches how the Spawn_Items.png is defined
func _init():
	for i in range(Global.spawnable_items.size()):
		mapping[i] = Global.spawnable_items[i]["name"].to_lower()
