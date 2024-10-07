extends GoblinState

func init():
	$Timer.start(5)
	goblin.sprite.play("await_input")

func _on_timer_timeout():
	get_parent().change_state("Explode")

func _on_goblin_listening_for_target():
	get_parent().updateProgress()
	$Timer.stop()
