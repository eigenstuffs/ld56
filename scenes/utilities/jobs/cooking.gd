extends Job

class_name CookingJob

@export var product : Recipe
@export var ingredient_gathered : Array[IngredientInfo] = []
@export var cook_time : int = 8
@export var drop_time : int = 2
@export var recipe_window : Recipe_Display

func init():
	if item_reward != null:
		ingredient_gathered.append(item_reward)
		item_reward = null
	recipe_window.show_recipe(product, ingredient_gathered)
	if recipe_window.done_gathering:
		time = cook_time
		item_reward = product
	else: time = drop_time

func give_reward():
	return null if item_reward == null else item_reward
	
func update_recipe(rec : Recipe):
	product = rec
	recipe_window.show_recipe(product, ingredient_gathered)
