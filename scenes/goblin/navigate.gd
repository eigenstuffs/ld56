extends GoblinState

func run():
	if goblin.item_holding == null:
		goblin.sprite.play("walking")
	else: goblin.sprite.play("walking_item")
