extends Job

class_name CookingJob

@export var product : Recipe
@export var ingredient_gathered : Array[IngredientInfo] = []
@export var cook_time : int = 8
@export var drop_time : int = 2

func init():
	if item_reward != null:
		ingredient_gathered.append(item_reward)
		item_reward = null
	var enough : bool = true
	if ingredient_gathered.size() >= items_needed.size():
		for item in items_needed:
			if item not in ingredient_gathered:
				enough = false
	else: enough = false
	if enough:
		time = cook_time
		item_reward = product
	else: time = drop_time
