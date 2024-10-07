extends Node2D

class_name Level

@export var next_level : Level
@export var n_goblins : int = 1
@export var progress_bar : ProgressBarManager
@export var cook : CookingJob
@export var recipe_list : Array[Recipe] = []
var recipe_index := 0
@onready var nav_control : Nav_Control= $NavControl
@onready var goblin = preload("res://scenes/goblin/goblin.tscn")
@onready var score_screen = preload("res://scenes/utilities/score_screen.tscn")
var paused := false
var time = 0
var ing_gathered = {}
var ing_needed = {}

func _ready():
	for n in range(n_goblins):
		var a = goblin.instantiate()
		a.connect("update_progress", update_progress)
		a.global_position = $GoblinSpawnPoint.global_position
		nav_control.goblin_folder.add_child(a)
	nav_control.init()
	var num_ings = 0
	for rec in recipe_list:
		num_ings += len(rec.required_ing)
	progress_bar.update_prep_progress(0,num_ings)
	progress_bar.update_cooking_progress(0,len(recipe_list))
	cook.update_recipe(recipe_list[0])
	
	
func _process(delta: float) -> void:
	if !paused: time += delta

func level_end():
	var n_star = calculate_score()
	var a = score_screen.instantiate()
	add_child(a)
	a.init(n_star)
	
	await a.confirmed
	#TODO Load and go to next scene

func calculate_score() -> int:
	return 3 #TODO replace placeholder
	#use the time var

func _on_plating_plating_complete():
	level_end()
	
func update_progress(stuff):
	if stuff is IngredientInfo:
		var ing : IngredientInfo = stuff
		progress_bar.update_prep_progress(ing.processed())
	elif stuff is Recipe:
		var rec : Recipe = stuff
		progress_bar.update_cooking_progress()

func update_ingredient(ing : IngredientInfo, quantity: int = 1, reqDict := false) -> void:
	var dict = ing_needed if reqDict else ing_gathered
	if dict.has(ing.ing_name): dict[ingredient_name] += quantity
	else: dict[ing.ing_name] = quantity
	
func remove_ingredient(ingredient_name: String, quantity: int = 1, reqDict := false) -> bool:
	if dict.has(ingredient_name) and ingredients[ingredient_name] >= quantity:
		dict[ingredient_name] -= quantity
		return true
	else:
		return false

func display_inventory() -> void:
	for ingredient in ingredients.keys():
		print("- ", ingredient.capitalize(), ":", ingredients[ingredient])

func reset_inventory() -> void:
	ingredients.clear()
