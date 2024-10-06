extends GoblinState

func init():
	$Timer.start(5)
	goblin.highlight.color = Color.ORANGE_RED
	goblin.sprite.play("await_input")

func _on_timer_timeout():
	get_parent().change_state("Eaten")

func _on_goblin_listening_for_target():
	$Timer.stop()
