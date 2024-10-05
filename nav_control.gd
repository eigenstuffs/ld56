extends Node2D

class_name Nav_Control

@onready var test_goblin = $"../GoblinPrototype"
@onready var test_goal = $"../Goal"

var goblin_array : Array[Goblin] = []
var agent_found : bool = false
var goal_found : bool = false

func _ready():
	goblin_array.push_back(test_goblin)
	
func _process(delta):
	if agent_found and goal_found:
		test_goblin.set_movement_target(test_goal.global_position)

func _on_goblin_prototype_listening_for_target():
	agent_found = true

func _on_goal_listening_for_agent():
	goal_found = true
