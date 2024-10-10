extends Job

class_name CookingJob

var product : Recipe
var ing_gathered := {}
@export var cook_time : int = 8
@export var drop_time : int = 0
signal ing_recieved(ing)	
@export var collectTask : PackedScene
@export var mixTasx : PackedScene
signal dur_job_interrupt

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
		task.global_position = $CollisionShape2D.global_position + Vector2(0,-40)
		task.connect("done", interrupt_dur_job)
		var bar = start_task_bar(gob)
		var timer = gob.get_tree().create_timer(time)
		timer.connect("timeout", interrupt_dur_job)
		await dur_job_interrupt
		if task.result != "win":
			gob.item_holding = null
			gob.change_state("Explode")
		else:
			await timer.timeout
		bar.queue_free()
	finish_dur_job()

func interrupt_dur_job():
	dur_job_interrupt.emit()

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
	if(gob.state != GoblinBase.STATE.EXPLODE):
		print("cooking.gd")
		gob.change_state("Idle")
	finish_post_job()
	
func check_trigger(gob : GoblinBase) -> bool:
	return gob.item_holding is IngredientInfo and gob.item_holding.state == 1
	
func start_cooking(rec : Recipe):
	product = rec
	time = 0
	for amt in rec.required_amount: time += 2
