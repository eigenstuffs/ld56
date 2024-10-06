extends Area2D

#Feel free to repurpose this class to task stations

class_name Goal

signal listening_for_agent
signal entered(goblin)

var clicked : bool = false
var occupied : bool = false
@onready var target_node : Node2D = self

func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("LMB"):
		if !occupied or true:#TODO shouldn't more than one be able to occupy?
			clicked = true
			emit_signal("listening_for_agent")
		#get_viewport().set_input_as_handled()

func _on_area_entered(area):
	if area.get_parent() is GoblinBase and area.get_parent().curr_target == target_node:
		occupied = true
		emit_signal("entered", area.get_parent())
		print("emitted")

func _on_area_exited(area):
	if area.get_parent() is GoblinBase:
		occupied = false
