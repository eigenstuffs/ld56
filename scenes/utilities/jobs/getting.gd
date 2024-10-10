extends Job

class_name GettingJob

@export var choosing_task : PackedScene
var ingredient_box : Array[IngredientInfo]

func pre_job(gob : GoblinBase):
	item_reward = null
	var task : ChoosingIngredient = choosing_task.instantiate()
	task.goblin = gob
	gob.add_child(task)
	task.global_position = gob.global_position
	play_random_animation(gob)
	print("Playing: " + gob.sprite.animation)
	await task.done
	play_random_animation(gob)
	item_reward = task.selected
	gob.hold_item(give_reward())
	task.queue_free()
	print("getting.gd")
	gob.change_state("Idle")
	finish_pre_job()
	
func check_trigger(gob : GoblinBase) -> bool:
	return gob.item_holding == null
	
