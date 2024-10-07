extends Control

class_name Recipe_Display

var task_list: TaskList = preload("res://scenes/tools/task/task_list.tres")

var label_theme = preload("res://scenes/menu/testing_purpose/test_theme.tres")
@onready var scroll_container = $Recipe/ScrollContainer
@onready var recipe_container = scroll_container.get_node("VBoxContainer")
var font_theme: Theme = preload("res://scenes/utilities/text_font.tres")
@onready var goblin_counter = $GoblinCounter
@onready var progress_bars = $"Progress Bars"

var ingredient_sprites = {
	"egg": "res://assets/ingredients/egg_cracked.png",
	"flour": "res://assets/ingredients/flour.png",
	"meat": "res://assets/ingredients/meat_defrosted.png",
	"secret": "res://assets/ingredients/secret_ingredient.png",
	"spices": "res://assets/ingredients/spice.png",
	"sugar": "res://assets/ingredients/sugar_measured.png",
	"veggie": "res://assets/ingredients/veggie_chopped.png"
}
var done_gathering = false

func _ready():
	self.theme = font_theme
	show_recipe(null, {})

func show_recipe(recipe : Recipe, ing_gathered : Dictionary) -> bool:
	clear_container(recipe_container)
	if(recipe == null): return false;
	
	done_gathering = true
	var title_container = VBoxContainer.new()
	title_container.add_theme_constant_override("separation", 0) 
	
	for name_line in recipe.dish_name.split("\n"):
		var line_label = Label.new()
		line_label.text = name_line
		line_label.align = 1 
		line_label.theme = label_theme
		title_container.add_child(line_label)

	recipe_container.add_child(title_container)
	for i in range(recipe.required_ing.size()):
		var ing_name = recipe.required_ing[i].ing_name
		var curr_amount = ing_gathered[ing_name] if ing_gathered.has(ing_name) else 0
		var req_amount: int = recipe.required_amount[i]
		done_gathering = done_gathering && curr_amount >= req_amount
		ing_name = format_ingredient_key(ing_name)
		
		var hbox = HBoxContainer.new()
		var texture = load_texture_for_ingredient(ing_name)
		if texture:
			var sprite = TextureRect.new()
			sprite.texture = texture
			hbox.add_child(sprite)

		var ingredient_label = Label.new()
		ingredient_label.text = str(curr_amount) + "/" + str(req_amount)
		ingredient_label.align = 1 
		ingredient_label.theme = label_theme
		ingredient_label.theme = label_theme
		ingredient_label.add_theme_font_override("font", font_theme.get_font("font", "Label"))
		hbox.add_child(ingredient_label)
		recipe_container.add_child(hbox)
	return done_gathering

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
		child.queue_free()

func get_player_inventory_amount(ing_name: String) -> int:
	return 0

func format_ingredient_key(ingredient_name: String) -> String:
	return (String)(ingredient_name).strip_edges().to_lower()
