extends GoblinState

func init():
	$Timer.start(5)
	goblin.sprite.play("await_input")
	notice_becomes_smaller()

func _on_timer_timeout():
	get_parent().change_state("Explode")

func _on_goblin_listening_for_target():
	get_parent().updateProgress()
	$Timer.stop()

func notice_becomes_smaller():
	var a = get_tree().create_tween()
	a.tween_property(goblin.item, "transform/scale", 0, 5)
	goblin.item.transform.scale = 1
