extends GoblinState

class_name Working

const JOB_PROGRESS : PackedScene = preload("res://scenes/goblin/job_progress.tscn")

func job(area : Job):
	goblin.change_state("Idle")
	area.goblins_engagaed += 1
	if area.goblins_engagaed >= area.goblins_needed:
		if area.items_needed.size() == 0 or goblin.item_holding in area.items_needed:
			area.pre_job(goblin)
			await area.job_done
			var b = JOB_PROGRESS.instantiate() as TextureProgressBar
			add_child(b)
			b.global_position = get_parent().global_position - Vector2(8, 24)
			area.dur_job(goblin)
			b.start(area.time)
			play_random_animation()
			await get_tree().create_timer(area.time).timeout
			print("Done job")
			b.queue_free()
			#area.post_job(goblin)
			#await area.job_done
			goblin.change_state("JobDone")
			goblin.hold_item(area.give_reward())

func play_random_animation():
	var n = randi_range(0, 2)
	if n == 0: goblin.sprite.play("working_front")
	else: goblin.sprite.play("working_back")
