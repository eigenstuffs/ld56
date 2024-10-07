extends Node2D

class_name Level

@export var next_level : Level
@export var n_goblins : int = 1
@onready var nav_control : Nav_Control= $NavControl
@onready var goblin = preload("res://scenes/goblin/goblin.tscn")
@onready var score_screen = preload("res://scenes/utilities/score_screen.tscn")

func _ready():
	for n in range(n_goblins):
		var a = goblin.instantiate()
		a.global_position = $GoblinSpawnPoint.global_position
		nav_control.goblin_folder.add_child(a)
	nav_control.init()

func level_end():
	var n_star = calculate_score()
	var a = score_screen.instantiate()
	add_child(a)
	a.init(n_star)
	
	await a.confirmed
	#TODO Load and go to next scene

func calculate_score() -> int:
	return 3 #TODO replace placeholder


func _on_plating_plating_complete():
	level_end()
