## Creates the rewards type and amount for the quests

extends Resource

class_name Rewards

@export var reward_type: String
@export var reward_amount: int = 1  

## Item based Rewards
@export var reward_item_id: String
@export var reward_item_quantity: int = 1

## Example
# reward_type="item", 
# reward_item_id="common_key", 
# reward_item_quantity=1
