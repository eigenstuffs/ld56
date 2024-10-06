extends Control

var task_list: TaskList = preload("res://scenes/tools/task/task_list.tres")
@onready var breakfast_recipe = preload("res://scenes/tools/recipes/breakfast_recipe.tres")
@onready var soup_recipe = preload("res://scenes/tools/recipes/soup_recipe.tres")
@onready var curry_recipe = preload("res://scenes/tools/recipes/curry_recipe.tres")
@onready var dessert_recipe = preload("res://scenes/tools/recipes/dessert_recipe.tres")

var label_theme = preload("res://scenes/menu/testing_purpose/test_theme.tres")
@onready var recipe_container = $Recipe/VBoxContainer

var recipes = []
var current_recipe_index = 0

func _ready():
	recipes = [breakfast_recipe, soup_recipe, curry_recipe, dessert_recipe]
	
	show_recipe(current_recipe_index)

func show_recipe(index):
	clear_container(recipe_container)

	if index < recipes.size():
		var recipe = recipes[index]
		
		var dish_name_label = Label.new()
		dish_name_label.text = recipe.dish_name
		dish_name_label.theme = label_theme
		recipe_container.add_child(dish_name_label)
		
		for i in range(recipe.required_ing.size()):
			var ing_name: String = recipe.required_ing[i].ing_name
			var req_amount: int = recipe.required_amount[i]
			var current_amount: int = get_player_inventory_amount(ing_name)  # use actual game logic to fetch inventory info

			var ingredient_label = Label.new()
			ingredient_label.text = ing_name + ": " + str(current_amount) + "/" + str(req_amount)
			ingredient_label.theme = label_theme

			print(str(recipe.enough(ing_name)))
			
			recipe_container.add_child(ingredient_label)
	else:
		print("Recipe index is out of bounds")

func clear_container(container: VBoxContainer):
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()

func complete_recipe():
	if current_recipe_index < recipes.size():
		# add logic to complete recipe
		current_recipe_index += 1
		if current_recipe_index < recipes.size():
			show_recipe(current_recipe_index)
		else:
			print("All recipes completed!")

func get_player_inventory_amount(ing_name: String) -> int:
	# add inventory
	return 0

func _input(event):
	if event.is_action_pressed("ui_accept"):
		complete_recipe()
