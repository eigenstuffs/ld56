extends CharacterBody2D

class_name GoblinBase

@export_enum("Idle", "Navigate", "Task", "Explode") var state

func _process(delta):
	match state:
		"Idle":
			$Idle.run()
		"Navigate":
			$Navigate.run()
		"Task":
			$Task.run()
		"Explode":
			$Explode.run()
