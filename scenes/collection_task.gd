extends Control

class_name CollectionTask

var goblin : GoblinBase
var result
signal done
	
func _ready() -> void:
	goblin.connect("state_changed", end_timer)
	goblin.change_state("Idle")
	$Timer.start(5)
	goblin.sprite.play("await_input")

func _on_timer_timeout():
	result = "lose"
	done.emit()

func end_timer(state : int):
	if(state == GoblinBase.STATE.AWAITING_INPUT):
		$Timer.stop()
		result = "win"
		done.emit()
