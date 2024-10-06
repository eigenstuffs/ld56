class_name Dialogue extends Control

@export var text : Array[String]
@onready var label : Label
@export var time_per_char : float = 0.02

signal next
signal done

func start():
	for i in text:
		label.visible_ratio = 0
		label.text = i
		var a = create_tween()
		a.tween_property(label,
			"visible_ratio", 1,
			time_per_char * i.length()
		)
		await next
	done.emit()
		
func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("LMB"):
		if label.visible_ratio == 1:
			next.emit()
		else:
			label.visible_ratio == 1
