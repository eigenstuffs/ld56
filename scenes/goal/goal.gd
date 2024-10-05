extends Area2D

class_name Goal

signal listening_for_agent

var clicked : bool = false

func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("LMB"):
		clicked = true
		print("you clicked on this area!") #TODO Remove this
		emit_signal("listening_for_agent")
