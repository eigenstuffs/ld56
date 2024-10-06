extends CanvasLayer

signal anim_done

func fade_in():
	$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished
	anim_done.emit()
	
func fade_out():
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	anim_done.emit()

func bars_down():
	$AnimationPlayer.play("bars_down")
	await $AnimationPlayer.animation_finished
	anim_done.emit()
	
func bars_up():
	$AnimationPlayer.play("bars_up")
	await $AnimationPlayer.animation_finished
	anim_done.emit()
