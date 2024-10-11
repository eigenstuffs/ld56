extends GoblinState

@export var chatter : Resource 
var orig_vol : int

func init():
	goblin.modulate = Color.WHITE
	if goblin.state == GoblinBase.STATE.IDLE:
		goblin.sprite.play("idle")
		print("playing idle")
		orig_vol = goblin.audio.volume_db
		goblin.audio.stream = chatter
		goblin.timer.stop()
		while goblin.state == GoblinBase.STATE.IDLE:
			goblin.timer.start(randi_range(0,10))
			await goblin.timer.timeout
			goblin.audio.volume_db = randi_range(orig_vol - 12, orig_vol - 5)
			goblin.audio.play()
			await goblin.audio.finished

func stop():
	goblin.timer.stop()
	goblin.audio.stop()
	goblin.audio.volume_db = orig_vol
	
func run():
	pass
	
