extends GoblinState

class_name Working

func job(area : Job):
	area.goblins_engagaed += 1
	if area.goblins_engagaed >= area.goblins_needed:
		if area.check_trigger(goblin):
			print("working.gd")
			goblin.change_state("Working")
			area.pre_job(goblin)
			if not area.pre_job_bool:
				await area.pre_job_done
			area.dur_job(goblin)
			if not area.dur_job_bool:
				await area.dur_job_done
			area.post_job(goblin)
			if not area.post_job_bool:
				await area.post_job_done
			area.queue_free()
