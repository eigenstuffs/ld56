extends Node2D

class_name Level

@export var next_level : Level #to be added
@export var n_goblins : int = 1
@export var recipe_manager : Recipe_Display
var progress_bar : ProgressBarManager
var goblin_counter : GoblinCounter
@export var cook : CookingJob
@export var birds : Bird_Window
@export var recipe_list : Array[Recipe] = []
var recipe_index := 0
@onready var nav_control : Nav_Control= $NavControl
@onready var goblin = preload("res://scenes/goblin/goblin.tscn")
@onready var score_screen = preload("res://scenes/utilities/score_screen.tscn")
@onready var chef_sprite = $Chef

var time = 0
var ing_gathered = {}
var ing_delivered = {}
var ing_needed = {}
var ing_total = 0

func _ready():
	progress_bar = recipe_manager.progress_bars
	birds.connect("gobs_changed", update_defense)
	birds.connect("def_failed", bird_penalty)
	goblin_counter = recipe_manager.goblin_counter
	goblin_counter.add_goblins(n_goblins)
	for n in range(n_goblins):
		var a = goblin.instantiate()
		a.connect("update_progress", update_progress)
		a.connect("state_changed", update_gob_count)
		a.global_position = $GoblinSpawnPoint.global_position
		nav_control.goblin_folder.add_child(a)
	nav_control.init()
	for rec in recipe_list:
		for ing : IngredientInfo in rec.required_ing:
			update_ingredient(ing, 1, 0)
			ing_total += 1
	update_prep_progress()
	cook.connect("ing_recieved", update_ingredient)
	recipe_manager.show_recipe(recipe_list[0], ing_delivered)
	
func _process(delta: float) -> void:
	if !get_tree().paused: time += delta

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
		update_ingredient(stuff, 1, 1)
	elif stuff is Recipe:
		recipe_index += 1
		progress_bar.update_cooking_progress(recipe_index, len(recipe_list))
		recipe_manager.show_recipe(recipe_list[recipe_index]
			if recipe_index < len(recipe_list) else null, ing_delivered)
			
func update_ingredient(ing : IngredientInfo, quantity: int = 1, dictNum = 2):
	if dictNum > 0 and not ing.processed(): return
	update_ingredient_str(ing.ing_name, quantity, dictNum)

func update_ingredient_str(ing : String, quantity: int = 1, dictNum = 2):
	if(dictNum == 0):
		if ing_needed.has(ing): ing_needed[ing] += quantity
		else: ing_needed[ing] = quantity
		return
	else:
		var dict = ing_gathered if dictNum == 1 else ing_delivered
		if dict.has(ing):
			dict[ing] += quantity
		else:
			dict[ing] = quantity
		update_prep_progress()
		if dictNum == 2 and recipe_manager.show_recipe(recipe_list[recipe_index], ing_delivered):
			cook.start_cooking(recipe_list[recipe_index])
			clear_recipe(recipe_list[recipe_index], 0)

func gob_death(carrying):
	if carrying is IngredientInfo:
		update_ingredient(carrying, -1, 1)
	elif carrying is Recipe:
		clear_recipe(carrying, 2)
	
func bird_penalty():
	var del_items = []
	for ing : String in ing_delivered.keys():
		for i in range(0, ing_delivered[ing]):
			del_items.append(ing)
	for i in range(birds.num_birds):
		if len(del_items) == 0 or randf() < 0.2:
			if recipe_index > 0:
				clear_recipe(recipe_list[randi_range(0,recipe_index - 1)], 1)
		else:
			update_ingredient_str(del_items[randi_range(0,len(del_items) - 1)], -1, 2)
			update_ingredient_str(del_items[randi_range(0,len(del_items) - 1)], -1, 1)
	
#mode is normal cooking, mode 1 is bird event, mode 2 is goblin died or cooking qte failed
func clear_recipe(recipe : Recipe, mode = 1):
	if mode == null:
		for i in range(len(recipe.required_ing)):
			update_ingredient(recipe.required_ing[i], -recipe.required_amount[i], 2)
	elif recipe_index > 0:
		for i in range(len(recipe.required_ing)):
			update_ingredient(recipe.required_ing[i], -recipe.required_amount[i], 1)
		recipe_index -= 1 if mode == 1 else 0
		recipe_list.insert(recipe_index + 1, recipe)
		recipe_list.pop_front()
		progress_bar.update_cooking_progress(recipe_index, len(recipe_list))
		
func update_prep_progress():
	var ing_count = 0
	for ing : String in ing_needed.keys():
		if(ing_gathered.has(ing)):
			ing_count += min(ing_gathered[ing], ing_needed[ing])
	progress_bar.update_prep_progress(ing_count, ing_total)

func update_gob_count(state : int, prev_state : int, carrying = null):
	if(state in [GoblinBase.STATE.EXPLODE, GoblinBase.STATE.EATEN]):
		gob_death(carrying)
	goblin_counter.update(state, prev_state)

func update_defense():
	progress_bar.update_def_progress(len(birds.goblins), birds.num_birds * 3)
