extends Node2D

class_name Level

@export var next_level : PackedScene
@export var music : Resource
@export var GOB_NAMES : Array[String] = ["Angelina", "Branden", "Caominh", "Joice", "Jon", "Lauclan", "Lea", "Nyla", "Osqurr"]
@export var n_goblins : int
var recipe_manager : Recipe_Display
var progress_bar : ProgressBarManager
var goblin_counter : GoblinCounter
var birds : Bird_Window
@export var max_birds = 1
@export var min_bird_time = 30
@export var max_bird_time = 40
@export var recipe_list : Array[Recipe] = []
var recipe_index := 0
var plated : Array[Recipe] = []
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
	$AudioStreamPlayer.stream = music
	$AudioStreamPlayer.play()
	
	birds = find_child("BirdWindow")
	birds.max_birds = max_birds
	birds.min_time = min_bird_time
	birds.max_time = max_bird_time
	recipe_manager = find_child("ToDoListUI")
	progress_bar = recipe_manager.progress_bars
	birds.connect("gobs_changed", update_defense)
	birds.connect("def_failed", bird_penalty)
	
	goblin_counter = recipe_manager.goblin_counter
	goblin_counter.add_goblins(n_goblins)
	GOB_NAMES.shuffle()
	for gob_name in GOB_NAMES.slice(0, n_goblins):
		var a = goblin.instantiate()
		a.gob_name = gob_name
		a.connect("update_progress", update_progress)
		a.connect("state_changed", update_gob_count)
		a.connect("ing_delivered", deliver_ingredient)
		a.connect("plate_delivered", deliver_plate)
		a.global_position = $GoblinSpawnPoint.global_position
		nav_control.goblin_folder.add_child(a)
	nav_control.init()
	
	var fridge : GettingJob = find_child("Getting")
	for rec in recipe_list:
		for ing : IngredientInfo in rec.required_ing:
			fridge.ingredient_box.append(ing)
			update_ingredient(ing, 1, 0)
			ing_total += 1
	update_prep_progress()
	recipe_manager.show_recipe(recipe_list[0], ing_delivered)
	
func _process(delta: float) -> void:
	if !get_tree().paused: time += delta

func level_end():
	var n_star = calculate_score()
	var a = score_screen.instantiate()
	add_child(a)
	a.init(n_star)
	
	await a.confirmed
	if a.next_level:
		get_tree().change_scene_to_packed(next_level)
	else:
		get_tree().reload_current_scene()

func calculate_score() -> int:
	return 3 #TODO replace placeholder
	#use the time var

func deliver_plate(plate : Recipe):
	plated.append(plate)
	if len(plated) == len(recipe_list):
		level_end()
	
func update_progress(stuff):
	if stuff is IngredientInfo and stuff.state == 1:
		update_ingredient(stuff, 1, 1)
	elif stuff is Recipe:
		recipe_index += 1
		progress_bar.update_cooking_progress(recipe_index, len(recipe_list))
		recipe_manager.show_recipe(recipe_list[recipe_index]
			if recipe_index < len(recipe_list) else null, ing_delivered)

func deliver_ingredient(ing : IngredientInfo, cook : CookingJob):
	if update_ingredient(ing):
		cook.start_cooking(recipe_list[recipe_index])

func update_ingredient(ing : IngredientInfo, quantity: int = 1, dictNum = 2) -> bool:
	return update_ingredient_str(ing.ing_name, quantity, dictNum)

func update_ingredient_str(ing : String, quantity: int = 1, dictNum = 2) -> bool:
	print(str(dictNum) + " - ING RECIEVED: " + ing)
	if(dictNum == 0):
		if ing_needed.has(ing): ing_needed[ing] += quantity
		else: ing_needed[ing] = quantity
		return false
	else:
		var dict = ing_gathered if dictNum == 1 else ing_delivered
		if dict.has(ing):
			dict[ing] += quantity
		else:
			dict[ing] = quantity
		if dictNum == 2 and recipe_index < len(recipe_list) \
			and	recipe_manager.show_recipe(recipe_list[recipe_index], ing_delivered):
			clear_recipe(recipe_list[recipe_index], 0)
			return true
		update_prep_progress()
		return false

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
			if len(plated) > 0:
				clear_recipe(plated.pop_at(randi_range(0,len(plated) - 1)), 1)
		else:
			update_ingredient_str(del_items[randi_range(0,len(del_items) - 1)], -1, 2)
			update_ingredient_str(del_items.pop_at(randi_range(0,len(del_items) - 1)), -1, 1)
	update_prep_progress()
	
#mode is normal cooking, mode 1 is bird event, mode 2 is goblin died or cooking qte failed
func clear_recipe(recipe : Recipe, mode = 1):
	if mode == 0:
		for i in range(len(recipe.required_ing)):
			update_ingredient(recipe.required_ing[i], -recipe.required_amount[i], 2)
	elif recipe != null:
		for i in range(len(recipe.required_ing)):
			update_ingredient(recipe.required_ing[i], -recipe.required_amount[i], 1)
		recipe_list.insert(recipe_index + 1, recipe)
		recipe_index -= 1
		recipe_list.pop_front()
		progress_bar.update_cooking_progress(recipe_index, len(recipe_list))
		progress_bar.update_prep_progress()
		
func update_prep_progress():
	var ing_count = 0
	for ing : String in ing_needed.keys():
		if(ing_gathered.has(ing)):
			ing_count += min(ing_gathered[ing], ing_needed[ing])
	progress_bar.update_prep_progress(ing_count, ing_total)

func update_gob_count(gob : GoblinBase, prev_state : int):
	if(gob.state in [GoblinBase.STATE.EXPLODE, GoblinBase.STATE.EATEN]):
		gob_death(gob.item_holding)
		goblin_counter.remove_goblins()
		goblin_counter.add_death_msg(gob)
	goblin_counter.update(gob.state, prev_state)

func update_defense():
	progress_bar.update_def_progress(len(birds.goblins), birds.num_birds * 3)
