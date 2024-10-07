extends Node2D

class_name Level

@export var next_level : Level
@export var n_goblins : int = 1
@export var progress_bar : ProgressBarManager
@export var recipe_list : Array[Recipe] = []
@onready var nav_control : Nav_Control= $NavControl
@onready var goblin = preload("res://scenes/goblin/goblin.tscn")
@onready var score_screen = preload("res://scenes/utilities/score_screen.tscn")
var paused := false
var time = 0

func _ready():
	for n in range(n_goblins):
		var a = goblin.instantiate()
		a.connect("update_progress", update_progress)
		a.global_position = $GoblinSpawnPoint.global_position
		nav_control.goblin_folder.add_child(a)
	nav_control.init()
	
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
