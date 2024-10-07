extends Job

class_name GettingJob

signal ingredient_gotten

@export var ingredient_box : Array[IngredientInfo]

func init():
	get_next_reward()

func get_next_reward():
	if ingredient_box.size() != 0:
		item_reward = ingredient_box.pop_front()
		item_reward.state = 1 if item_reward.state == 0 else 0
	
func give_reward():
	ingredient_gotten.emit()
	if item_reward == null:
		return null
	return item_reward
