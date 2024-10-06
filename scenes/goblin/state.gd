class_name GoblinState extends Node

@onready var goblin = get_parent() as GoblinBase
@onready var anim = goblin.find_child("AnimationPlayer") as AnimationPlayer

var running : bool = false

func init():
	pass

func run():
	pass
	
func change_state(to : String):
	goblin.change_state(to)

func stop():
	pass
