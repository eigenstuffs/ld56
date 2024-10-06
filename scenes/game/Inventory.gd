extends Node

class_name Inventory

var ingredients = {}

func add_ingredient(ingredient_name: String, quantity: int = 1) -> void:
	if ingredients.has(ingredient_name):
		ingredients[ingredient_name] += quantity
	else:
		ingredients[ingredient_name] = quantity
	print("Added", quantity, ingredient_name, "to inventory. Total:", ingredients[ingredient_name])

func remove_ingredient(ingredient_name: String, quantity: int = 1) -> bool:
	if ingredients.has(ingredient_name) and ingredients[ingredient_name] >= quantity:
		ingredients[ingredient_name] -= quantity
		print("Removed", quantity, ingredient_name, "from inventory. Remaining:", ingredients[ingredient_name])
		return true
	else:
		print("Not enough", ingredient_name, "to remove.")
		return false

func get_ingredient_quantity(ingredient_name: String) -> int:
	return ingredients.get(ingredient_name, 0)

func display_inventory() -> void:
	print("Inventory:")
	for ingredient in ingredients.keys():
		print("- ", ingredient.capitalize(), ":", ingredients[ingredient])

func reset_inventory() -> void:
	ingredients.clear()
	print("Inventory has been reset.")
