extends Job

class_name GettingJob

@export var ingredient_box : Array[IngredientInfo]

func init():
	get_next_reward()

func get_next_reward():
	if ingredient_box.size() != 0:
		item_reward = ingredient_box.pop_front()
	
func give_reward():
	item_reward.state = 0
	return item_reward
