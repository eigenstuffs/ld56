extends Area2D

#Feel free to repurpose this class to task stations

class_name Goal

signal listening_for_agent

var clicked : bool = false
var occupied : bool = false

func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("LMB"):
		if !occupied:
			clicked = true
			emit_signal("listening_for_agent")
		#get_viewport().set_input_as_handled()


func _on_area_entered(area):
	if area.get_parent() is GoblinBase:
		occupied = true

func _on_area_exited(area):
	if area.get_parent() is GoblinBase:
		occupied = false
