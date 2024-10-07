extends GoblinState

func init():
	goblin.input_pickable = false
	goblin.sprite.play("explode")
	await goblin.sprite.animation_finished
	goblin.queue_free()
	
func run():
	pass
