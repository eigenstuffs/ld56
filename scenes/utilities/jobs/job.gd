class_name Job extends Area2D

@export var time : int
var items_needed : Array
@export var goblins_needed : int = 1
@export var JOB_PROGRESS : PackedScene
var goblins_engagaed : int = 0
var item_reward : Resource

signal pre_job_done
var pre_job_bool : bool = false
signal dur_job_done
var dur_job_bool : bool = false
signal post_job_done
var post_job_bool : bool = false

func pre_job(goblin : GoblinBase):
	finish_pre_job()
	
func finish_pre_job():
	pre_job_done.emit()
	pre_job_bool = true
	
func dur_job(goblin : GoblinBase):
	if JOB_PROGRESS != null and time > 0:
		var bar = start_task_bar(goblin)
		await goblin.get_tree().create_timer(time).timeout
		bar.queue_free()
	finish_dur_job()
	
func finish_dur_job():
	dur_job_done.emit()
	dur_job_bool = true
	
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
	if n == 0: goblin.sprite.play("working_front")
	else: goblin.sprite.play("working_back")

func start_task_bar(gob : GoblinBase) -> TextureProgressBar:
	if JOB_PROGRESS == null : return null
	var b = JOB_PROGRESS.instantiate() as TextureProgressBar
	gob.add_child(b)
	b.global_position = gob.global_position + Vector2(-8,-28)
	b.start(time)
	return b
