extends Node2D

class_name Nav_Control

@onready var goblin_folder = $GoblinFolder
@onready var goal_folder = $GoalFolder
var goblin_array : Array[GoblinBase] = []
@export var goal_array : Array[Goal] = []
var agent_found : bool = false
var goal_found : bool = false

func _ready():
	pass

func init():
	for goblin : GoblinBase in goblin_folder.get_children():
		goblin_array.append(goblin)
		goblin.connect("listening_for_target", _on_goblin_listening_for_target)
	for goal : Goal in goal_folder.get_children():
		goal_array.append(goal)
		print(goal)
	for goal : Goal in goal_array:
		goal.connect("listening_for_agent", _on_goal_listening_for_agent)
	
func _process(delta):
	#logic: if both and agent and a goal are clicked, let agent go to the goal
	if agent_found and goal_found:
		var target_goblins : Array[GoblinBase]
		var target_goal : Goal
		for goblin : GoblinBase in goblin_array:
			if goblin != null:
				if goblin.clicked:
					target_goblins.append(goblin)
					goblin.clicked = false
		for goal : Goal in goal_array:
			if goal.clicked:
				target_goal = goal.target_node
				goal.clicked = false
		for goblin : GoblinBase in target_goblins:
			goblin.set_movement_target(target_goal)
		goal_found = false
		agent_found = false

func _on_goblin_listening_for_target():
	agent_found = true

func _on_goal_listening_for_agent():
	goal_found = agent_found
