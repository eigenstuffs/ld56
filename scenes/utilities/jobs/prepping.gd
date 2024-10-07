extends Job

class_name PreppingJob

@export var collectTask : PackedScene

func pre_job(gob : GoblinBase):
	item_reward = gob.item_holding
	time = item_reward.prep_time
	gob.remove_item()
	finish_pre_job()

func post_job(gob : GoblinBase):
	var task : CollectionTask = collectTask.instantiate()
	task.goblin = gob
	get_tree().current_scene.add_child(task)
	task.global_position = gob.global_position
	await task.done
	print("done")
	print(task.result)
	if(task.result == "lose"):
		gob.change_state("Explode")
	else:
		gob.hold_item(give_reward())
		gob.change_state("Idle")
		finish_post_job()

func check_trigger(gob : GoblinBase) -> bool:
	return gob.item_holding is IngredientInfo and gob.item_holding.state == 0
