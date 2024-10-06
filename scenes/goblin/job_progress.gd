extends TextureProgressBar

func start(time : int):
	var a = create_tween()
	a.tween_property(self, "value", 100, time)
	await a.finished
	$AnimationPlayer.play("flash")
