extends CharacterBody2D

class_name GoblinBase

@export_enum("Idle",
	"Navigate",
	"Working",
	"AwaitingInput",
	"Explode") var state

func _process(delta):
	match state:
		"Idle":
			$Idle.run()
		"Navigate":
			$Navigate.run()
		"Working":
			$Working.run()
		"AwaitingInput":
			$AwaitingInput.run()
		"Explode":
			$Explode.run()
