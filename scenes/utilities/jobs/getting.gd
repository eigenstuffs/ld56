extends Job

class_name GettingJob

@export var choosing_task : PackedScene
@export var ingredient_box : Array[IngredientInfo]

func pre_job(gob : GoblinBase):
	item_reward = null
	var task : ChoosingIngredient = choosing_task.instantiate()
	get_tree().current_scene.add_child(task)
	task.global_position = gob.global_position
	await task.done
	item_reward = task.selected
	gob.hold_item(give_reward())
	finish_pre_job()
	task.queue_free()
	
func check_trigger(gob : GoblinBase) -> bool:
	return gob.item_holding == null
	
