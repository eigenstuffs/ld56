extends Control

var task_list : TaskList = preload("res://scenes/tools/task/task_list.tres")
@onready var breakfast_recipe = preload("res://scenes/tools/recipes/breakfast_recipe.tres")
var label_theme = preload("res://scenes/menu/testing_purpose/test_theme.tres")
@onready var recipe_container = $"../NinePatchRect4/VBoxContainer"

func _ready():
	for index in range(get_child_count()):
		get_child(index).value = task_list.task_array[index].total_time
		print(task_list.task_array[index].total_time)
	
	
	for index in range(breakfast_recipe.required_ing.size()):
		var ing_name : String = breakfast_recipe.required_ing[index].ing_name
		var req_amount : int = breakfast_recipe.required_amount[index]
		var current_amount : int = 0
		var a = Label.new()
		a.text = ing_name + ": " + str(current_amount) + "/" + str(req_amount)
		a.theme = label_theme
		print(str(breakfast_recipe.enough(ing_name)))
		recipe_container.add_child(a)
