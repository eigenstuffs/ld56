extends Node2D

class_name GoblinSpawner

@export var max_goblin : int
@export var spawn_interval : float
@export var spawn_folder : Node2D #should be set to the goblin folder under nav control

@onready var goblin = preload("res://scenes/goblin/goblin.tscn")
@onready var timer : Timer = $Timer
@onready var spawn_area = $"../ColorRect"

var current_goblin_count : int
var spawn_area_center : Vector2

func _ready():
	timer.start(spawn_interval)
	spawn_area_center = spawn_area.global_position


func _on_timer_timeout():
	check_and_spawn_goblin()
	timer.start(spawn_interval)
	
func check_and_spawn_goblin():
	if current_goblin_count < max_goblin:
		var a = goblin.instantiate()
		a.global_position.x = randi_range(spawn_area_center.x - 50, spawn_area_center.x + 50)
		a.global_position.y = randi_range(spawn_area_center.y - 50, spawn_area_center.y + 50)
		spawn_folder.add_child(a)
		current_goblin_count = count_goblins(spawn_folder)

func count_goblins(folder):
	var counts : int = 0
	for child in folder.get_children():
		if child is GoblinBase:
			counts += 1
	return counts
