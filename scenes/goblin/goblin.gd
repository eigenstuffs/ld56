extends CharacterBody2D

class_name GoblinBase

@export_enum(
	"Idle",
	"Navigate",
	"Working",
	"AwaitingInput",
	"Explode"
) var state = "Idle"

func _process(delta):
	find_child(state).run()

func change_state(to : String):
	state = to
	find_child(state).init()
