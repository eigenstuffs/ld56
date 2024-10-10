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
	gob.emit_signal("ing_delivered", gob.item_holding, self)
	print("delivered emit")
	gob.remove_item()
	finish_pre_job()

func dur_job(gob : GoblinBase):
	if(product != null):
		play_random_animation(gob)
		gob.item_holding = product
		product = null
		var task : Mix = mixTasx.instantiate()
		task.length = time
		gob.add_child(task)
		task.global_position = gob.global_position + Vector2(0, 0.2)
		await task.done
		if(task.result == "lose"):
			gob.change_state("Explode")
			return
	
func post_job(gob : GoblinBase):
	if(gob.item_holding is Recipe):
		var task : CollectionTask = collectTask.instantiate()
		task.goblin = gob
		gob.add_child(task)
		task.global_position = gob.global_position
		await task.done
		if(task.result == "lose"):
			gob.change_state("Explode")
			return
		gob.hold_item(gob.item_holding)
		task.queue_free()
	print("cooking.gd")
	gob.change_state("Idle")
	finish_post_job()
	
func check_trigger(gob : GoblinBase) -> bool:
	return gob.item_holding is IngredientInfo and gob.item_holding.state == 1
	
func start_cooking(rec : Recipe):
	print("ASFAFSADASD")
	product = rec
	time = 0
	for amt in rec.required_amount: time += 2
