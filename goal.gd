extends Area2D

class_name Goal

signal listening_for_agent

func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("LMB"):
		print("you clicked on this area!")
		emit_signal("listening_for_agent")
