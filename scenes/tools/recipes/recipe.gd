extends Resource

class_name Recipe

@export var dish_name : String
@export var recipe_img : Texture2D
@export var required_ing : Array[IngredientInfo] = []
@export var required_amount : Array[int] = []
@export var current_amount : Array[int]

#getters
func find_by_name(name : String):
	for item in required_ing:
		if item.ing_name == name:
			return item
	push_warning(name + " does not exist in the recipe!")
	return null

func enough(name : String) -> bool:
	var index := required_ing.find(find_by_name(name))
	if current_amount[index] >= required_amount[index]:
		return true
	return false
	
#setters
func ingredient_acquired(name : String, quantity : int = 1):
	var index := required_ing.find(find_by_name(name))
	current_amount[index] += quantity
