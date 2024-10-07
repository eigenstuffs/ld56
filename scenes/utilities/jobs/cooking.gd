extends Job

class_name CookingJob

@export var product : Recipe
@export var ingredient_gathered = []
var ing_gathered := {}
@export var cook_time : int = 8
@export var drop_time : int = 0
signal ing_recieved(ing)
@export var collectTask : PackedScene

func pre_job(gob : GoblinBase):
	ingredient_gathered.append(gob.item_holding.ing_name)
	emit_signal("ing_recieved", gob.item_holding)
	gob.remove_item()
	var count : int = 0
	for item in items_needed:
		if item.ing_name in ingredient_gathered:
			count += 1
	if count >= items_needed.size():
		item_reward = product
		time = cook_time
	else: time = drop_time
	finish_pre_job()
	
func post_job(gob : GoblinBase):
	if(product != null):
		var task : CollectionTask = collectTask.instantiate()
		task.goblin = gob
		get_tree().current_scene.add_child(task)
		task.global_position = gob.global_position
		await task.done
		if(task.result == "lose"):
			gob.change_state("Explode")
			return
		gob.hold_item(give_reward())
		gob.change_state("Idle")
		finish_post_job()
		task.queue_free()
	
func init():
	if item_reward != null:
		emit_signal("ing_recieved", item_reward)
		item_reward = null

func give_reward():
	var prod = product
	product = null
	time = drop_time
	return prod
	
func check_trigger(gob : GoblinBase) -> bool:
	return gob.item_holding is IngredientInfo and gob.item_holding.state == 1
	
func start_cooking(rec : Recipe):
	product = rec
	time = cook_time
