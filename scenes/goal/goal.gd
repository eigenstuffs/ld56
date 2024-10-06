extends Area2D

#Feel free to repurpose this class to task stations

class_name Goal

signal listening_for_agent

var clicked : bool = false

func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("LMB"):
		clicked = true
		emit_signal("listening_for_agent")
