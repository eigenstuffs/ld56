extends Job

class_name PreppingJob

@export var collectTask : PackedScene

func pre_job(gob : GoblinBase):
	play_random_animation(gob)
	item_reward = gob.item_holding
	time = item_reward.prep_time
	gob.remove_item()
	finish_pre_job()

func post_job(gob : GoblinBase):
	gob.sprite.play("await_input")
	var task : CollectionTask = collectTask.instantiate()
	task.goblin = gob
	gob.add_child(task)
	task.global_position = gob.global_position
	await task.done
	if(task.result == "lose"):
		gob.change_state("Explode")
	else:
		gob.hold_item(give_reward())
		print("prepping.gd")
		gob.change_state("Idle")
		finish_post_job()
	task.queue_free()

func check_trigger(gob : GoblinBase) -> bool:
	return gob.item_holding is IngredientInfo and gob.item_holding.state == 0
