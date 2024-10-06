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

var ingredient_sprites = {
	"egg": "res://assets/ingredients/egg.png",
	"flour": "res://assets/ingredients/flour.png",
	"meat": "res://assets/ingredients/meat_frosted.png",
	"secret": "res://assets/ingredients/secret_ingredient.png",
	"spices": "res://assets/ingredients/spice.png",
	"sugar": "res://assets/ingredients/sugar.png",
	"veggie": "res://assets/ingredients/veggie.png"
}

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
			var ing_name = String(recipe.required_ing[i].ing_name) 
			
			if typeof(ing_name) != TYPE_STRING:
				print("Unexpected type for ing_name:", typeof(ing_name))
				continue

			ing_name = format_ingredient_key(ing_name)
			var req_amount: int = recipe.required_amount[i]
			var current_amount: int = get_player_inventory_amount(ing_name)

			var hbox = HBoxContainer.new()

			var texture = load_texture_for_ingredient(ing_name)
			if texture:
				var sprite = TextureRect.new()
				sprite.texture = texture
				hbox.add_child(sprite)

			var ingredient_label = Label.new()
			ingredient_label.text = ing_name.capitalize() + ": " + str(current_amount) + "/" + str(req_amount)
			ingredient_label.theme = label_theme
			hbox.add_child(ingredient_label)

			print("Sufficient ingredient?", recipe.enough(ing_name))

			recipe_container.add_child(hbox)
	else:
		print("Recipe index is out of bounds")

func load_texture_for_ingredient(ingredient_name: String) -> Texture:
	if ingredient_name in ingredient_sprites:
		var texture = load(ingredient_sprites[ingredient_name])
		if texture:
			print("Loaded texture for ingredient:", ingredient_name)
		else:
			print("Failed to load texture for ingredient:", ingredient_name)
		return texture
	else:
		print("Ingredient name not in sprite map:", ingredient_name)
	return null

func clear_container(container: VBoxContainer):
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()

func complete_recipe():
	if current_recipe_index < recipes.size():
		
		current_recipe_index += 1
		if current_recipe_index < recipes.size():
			show_recipe(current_recipe_index)
		else:
			print("All recipes completed!")

func get_player_inventory_amount(ing_name: String) -> int:
	# Placeholder for inventory
	return 0

func format_ingredient_key(ingredient_name: String) -> String:
	return ingredient_name.strip_edges().to_lower()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		complete_recipe()
