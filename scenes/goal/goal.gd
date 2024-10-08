extends Area2D

#Feel free to repurpose this class to task stations

class_name Goal

signal listening_for_agent(goal : Goal)
signal entered(goblin : GoblinBase)

var clicked : bool = false
var occupied : bool = false
@onready var target_node : Node2D = self

func _on_input_event(_viewport, event : InputEvent, _shape_idx):
	if event.is_action_pressed("LMB"):
		print("test")
		emit_signal("listening_for_agent", self)
		#get_viewport().set_input_as_handled()

func _on_area_entered(area):
	if area.get_parent() is GoblinBase and area.get_parent().curr_target == target_node:
		occupied = true
		emit_signal("entered", area.get_parent())

func _on_area_exited(area):
	if area.get_parent() is GoblinBase:
		occupied = false
