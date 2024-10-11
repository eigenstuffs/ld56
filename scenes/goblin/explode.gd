extends GoblinState

@export var audio : Resource
@export var text : Resource

func init():
	goblin.input_pickable = false
	goblin.audio.stream = audio
	goblin.audio.play()
	goblin.sprite.play("explode")
	await goblin.sprite.animation_finished
	goblin.queue_free()
	
func run():
	pass
