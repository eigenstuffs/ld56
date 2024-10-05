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
