extends Control

class_name CollectionTask

var goblin : GoblinBase
var result
signal done
	
func _ready() -> void:
	goblin.change_state("Idle")
	goblin.connect("clicked_on", end_timer)
	$Timer.start(5)
	goblin.sprite.play("await_input")

func _on_timer_timeout():
	result = "lose"
	done.emit()

func end_timer(state : int):
	$Timer.stop()
	result = "win"
	done.emit()
