class_name Job extends Area2D

@export var time : int
@export var items_needed : Array
@export var goblins_needed : int = 1
@export var goblins_engagaed : int = 0
@export var item_reward : Resource

signal pre_job_done
var pre_job_bool : bool = false
signal post_job_done
var post_job_bool : bool = false

func pre_job(goblin : GoblinBase):
	finish_pre_job()
	
func finish_pre_job():
	pre_job_done.emit()
	pre_job_bool = true
	
func dur_job(goblin : GoblinBase):
	pass
	
func post_job(gob : GoblinBase):
	gob.hold_item(give_reward())
	print("job.gd")
	gob.change_state("Idle")
	finish_post_job()

func finish_post_job():
	post_job_done.emit()
	post_job_bool = true

func check_trigger(gob : GoblinBase) -> bool:
	return items_needed.size() == 0
	
func give_reward():
	if item_reward == null:
		return null
	else:
		var reward : IngredientInfo = item_reward.duplicate()
		reward.state = 1 if reward.state == 0 else 0
		return reward

func play_random_animation(goblin : GoblinBase):
	var n = randi_range(0, 2)
	if n == 0: goblin.sprite.play("working_back")
	else: goblin.sprite.play("working_back")
	print("should be working")
