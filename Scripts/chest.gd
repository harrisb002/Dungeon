extends StaticBody2D

enum ChestType {COMMON, GOLDEN, BOSS}

signal chest_zone_entered
signal chest_zone_exited

# Chest type default to common, (Can set in Inspector)
@export var chest_type : ChestType 

# Dict to map enum values to key names
var chest_keys = {
	ChestType.COMMON: "Common",
	ChestType.GOLDEN: "Golden",
	ChestType.BOSS: "Boss"
}

var nearby_chest = false

func _ready() -> void:
	$open.visible = false
	$closed.visible = true

func _process(delta: float):
	if nearby_chest and Input.is_action_just_pressed("open"):
		print("nearby chest and opening")
		# Pass the reference to the chest
		open_chest(self, chest_type)

func _on_chest_zone_body_entered(body):
	if body.is_in_group("player"):
		nearby_chest = true
		body.inventory_ui_label.text = "Press O to pickup"
		body.interact_ui.visible = true

func _on_chest_zone_body_exited(body):
	if body.is_in_group("player"):
		nearby_chest = false
		body.inventory_ui_label.text = "Press Enter to pickup"
		body.interact_ui.visible = false

# Handles opening all chest types based on keys present in inventory
func open_chest(chest: StaticBody2D, chest_type):	
	## Get the key string from the Dict
	var key_type = chest_keys.get(chest_type, null)
	if key_type == null:
		print("No Chest of this type exists")
		return
	
	## Check if player has key in inventory
	if key_type != null and Global_Inventory.has_key_in_inventory("Key", key_type):
		# Remove the key from the player's inventory
		Global_Inventory.remove_item("Key", key_type)
		## Make the chest Open
		$open.visible = true
		$closed.visible = false
	else:
		print("You need a ", chest_keys.get(chest_type, null), " key to open this chest.")
