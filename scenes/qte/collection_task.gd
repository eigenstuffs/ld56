extends Control

class_name CollectionTask

var goblin : GoblinBase
var result
signal done
	
func _ready() -> void:
	goblin.connect("clicked_on", end_timer)
	$Timer.start(5)

func _on_timer_timeout():
	result = "lose"
	done.emit()

func end_timer():
	$Timer.stop()
	result = "win"
	done.emit()
