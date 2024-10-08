extends Job

class_name CookingJob

var product : Recipe
var ing_gathered := {}
@export var cook_time : int = 8
@export var drop_time : int = 0
signal ing_recieved(ing)	
@export var collectTask : PackedScene
@export var mixTasx : PackedScene

func pre_job(gob : GoblinBase):
	emit_signal("ing_recieved", gob.item_holding)
	gob.remove_item()
	finish_pre_job()

func dur_job(gob : GoblinBase):
	if(product != null):
		gob.item_holding = product
		var task : Mix = mixTasx.instantiate()
		task.length = time
		get_tree().current_scene.add_child(task)
		task.global_position = gob.global_position + Vector2(0, 0.2)
		await task.done
		if(task.result == "lose"):
			gob.change_state("Explode")
			return
	
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
		task.queue_free()	
		reset_cook()
	gob.change_state("Idle")
	finish_post_job()

func give_reward():
	var prod = product
	product = null
	time = drop_time
	return prod
	
func check_trigger(gob : GoblinBase) -> bool:
	return gob.item_holding is IngredientInfo and gob.item_holding.state == 1

func reset_cook():
	product = null
	time = 0
	
func start_cooking(rec : Recipe):
	product = rec
	time = 0
	for amt in rec.required_amount: time += 2
