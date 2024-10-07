extends GoblinState

func init():
	goblin.modulate = Color(171.0/255, 1, 195.0/255)
	goblin.sprite.play("await_input")
	print("await input played")
	
func run():
	pass
