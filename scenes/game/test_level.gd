extends Node2D

class_name Level

@export var next_level : Level #to be added
@export var n_goblins : int = 1
@export var recipe_manager : Recipe_Display
@export var progress_bar : ProgressBarManager
var goblin_counter : GoblinCounter
@export var cook : CookingJob
@export var recipe_list : Array[Recipe] = []
var recipe_index := 0
@onready var nav_control : Nav_Control= $NavControl
@onready var goblin = preload("res://scenes/goblin/goblin.tscn")
@onready var score_screen = preload("res://scenes/utilities/score_screen.tscn")
@onready var chef_sprite = $Chef

var paused := false
var time = 0
var ing_gathered = {}
var ing_delivered = {}
var ing_needed = {}
var ing_total = 0

func _ready():
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
	updateProgressBars()
	cook.connect("ing_recieved", deliver_ingredient)
	recipe_manager.show_recipe(recipe_list[0], ing_delivered)
	
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
		update_ingredient(stuff)
	elif stuff is Recipe:
		recipe_index += 1
		recipe_manager.show_recipe(recipe_list[recipe_index], ing_delivered)

func deliver_ingredient(ing : IngredientInfo, quantity : int = 1):
	if update_ingredient(ing, quantity, 2):
		cook.start_cooking(recipe_list[recipe_index])	

func update_ingredient(ing : IngredientInfo, quantity: int = 1, dictNum = 1) -> bool:
	if dictNum > 0 and not ing.processed(): return false
	if(dictNum == 0):
		if ing_needed.has(ing.ing_name): ing_needed[ing.ing_name] += quantity
		else: ing_needed[ing.ing_name] = quantity
		return false
	else:
		var dict = ing_gathered if dictNum == 1 else ing_delivered
		if dict.has(ing.ing_name):
			dict[ing.ing_name] += quantity
		else:
			dict[ing.ing_name] = quantity
		updateProgressBars()
		return dictNum != 1 and recipe_manager.show_recipe(recipe_list[recipe_index], ing_delivered)

func updateProgressBars():
	var ing_count = 0
	for ing : String in ing_needed.keys():
		if(ing_gathered.has(ing)):
			ing_count += min(ing_gathered[ing], ing_needed[ing])
	progress_bar.update_prep_progress(ing_count, ing_total)

func update_gob_count(state : int, prev_state : int):
	goblin_counter.update(state, prev_state)
