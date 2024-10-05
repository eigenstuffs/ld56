extends Label


# extends Control

var task_list : TaskList = preload("res://scenes/tools/task/task_list.tres")

func _ready():
	var recipe_ingredients = task_list.task_array[0].ingredients

	for index in range(min(4, recipe_ingredients.size())):
		var ingredient_label = get_child(index)
		if ingredient_label:
			ingredient_label.text = recipe_ingredients[index]
			print("Ingredient", index + 1, ":", recipe_ingredients[index])
