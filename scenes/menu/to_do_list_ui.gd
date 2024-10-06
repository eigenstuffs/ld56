extends Control

var task_list : TaskList = preload("res://scenes/tools/task/task_list.tres")
@onready var breakfast_recipe = preload("res://scenes/tools/recipes/breakfast_recipe.tres")
var label_theme = preload("res://scenes/menu/testing_purpose/test_theme.tres")
@onready var recipe_container = $Recipe/VBoxContainer

func _ready():
	#for index in range(get_child_count()):
	#	get_child(index).value = task_list.task_array[index].total_time
	#	print(task_list.task_array[index].total_time)
	
	#breakfast
	for index in range(breakfast_recipe.required_ing.size()):
		var ing_name : String = breakfast_recipe.required_ing[index].ing_name
		var req_amount : int = breakfast_recipe.required_amount[index]
		var current_amount : int = 0
		var a = Label.new()
		a.text = ing_name + ": " + str(current_amount) + "/" + str(req_amount)
		a.theme = label_theme
		print(str(breakfast_recipe.enough(ing_name)))
		recipe_container.add_child(a)
	
	#lunch	
	for index in range(soup_recipe.required_ing.size()):
		var ing_name : String = soup_recipe.required_ing[index].ing_name
		var req_amount : int = soup_recipe.required_amount[index]
		var current_amount : int = 0
		var a = Label.new()
		a.text = ing_name + ": " + str(current_amount) + "/" + str(req_amount)
		a.theme = label_theme
		print(str(soup_recipe.enough(ing_name)))
		recipe_container.add_child(a)
		
	#dinner
	for index in range(curry_recipe.required_ing.size()):
		var ing_name : String = curry_recipe.required_ing[index].ing_name
		var req_amount : int = curry_recipe.required_amount[index]
		var current_amount : int = 0
		var a = Label.new()
		a.text = ing_name + ": " + str(current_amount) + "/" + str(req_amount)
		a.theme = label_theme
		print(str(curry_recipe.enough(ing_name)))
		recipe_container.add_child(a)
		
	#dessert
	for index in range(dessert_recipe.required_ing.size()):
		var ing_name : String = dessert_recipe.required_ing[index].ing_name
		var req_amount : int = dessert_recipe.required_amount[index]
		var current_amount : int = 0
		var a = Label.new()
		a.text = ing_name + ": " + str(current_amount) + "/" + str(req_amount)
		a.theme = label_theme
		print(str(dessert_recipe.enough(ing_name)))
		recipe_container.add_child(a)
