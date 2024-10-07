extends Job

class_name GettingJob

signal ingredient_gotten

@export var ingredient_box : Array[IngredientInfo]

func pre_job(gob : GoblinBase):
	var a : ChoosingIngredient = qte.instantiate()
	get_tree().current_scene.add_child(a)
	a.global_position = get_parent().global_position - Vector2(0, 16)
	await a.done
	if a.result == "lose":
		gob.change_state("Explode")
		return
	job_done.emit()
		
func dur_job(gob : GoblinBase):
	get_next_reward()

func post_job(gob :GoblinBase):
	job_done.emit()

func get_next_reward():
	if ingredient_box.size() != 0:
		item_reward = ingredient_box.pop_front()
		item_reward.state = 1 if item_reward.state == 0 else 0
	
func give_reward():
	ingredient_gotten.emit()
	if item_reward == null:
		return null
	return item_reward
	
