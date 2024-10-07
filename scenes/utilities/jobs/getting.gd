extends Job

class_name GettingJob

@export var choosing_task : PackedScene
@export var ingredient_box : Array[IngredientInfo]

func pre_job(gob : GoblinBase):
	var task : ChoosingIngredient = choosing_task.instantiate()
	get_tree().current_scene.add_child(task)
	task.global_position = gob.global_position
	await task.done
	item_reward = task.selected
	finish_pre_job()
	
func check_trigger(gob : GoblinBase) -> bool:
	return gob.item_holding == null
	
