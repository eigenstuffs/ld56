extends GoblinState

class_name Working

const JOB_PROGRESS : PackedScene = preload("res://scenes/goblin/job_progress.tscn")

func job(area : Job):
	area.goblins_engagaed += 1
	if area.goblins_engagaed >= area.goblins_needed:
		if area.check_trigger(goblin):
			goblin.change_state("Working")
			print("working")
			area.pre_job(goblin)
			if not area.pre_job_bool:
				await area.pre_job_done
			var b = JOB_PROGRESS.instantiate() as TextureProgressBar
			add_child(b)
			b.global_position = get_parent().global_position - Vector2(8, 24)
			area.dur_job(goblin)
			b.start(area.time)
			await get_tree().create_timer(area.time).timeout
			b.queue_free()
			area.post_job(goblin)
			if not area.post_job_bool:
				await area.post_job_done
			area.queue_free()
