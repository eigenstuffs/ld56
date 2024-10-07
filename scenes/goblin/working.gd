extends GoblinState

class_name Working

const JOB_PROGRESS : PackedScene = preload("res://scenes/goblin/job_progress.tscn")

func job(area : Job):
	goblin.change_state("Idle")
	area.goblins_engagaed += 1
	if area.goblins_engagaed >= area.goblins_needed:
		if area is CookingJob:
			area.give_product(goblin)
			goblin.item.texture = goblin.item_holding.recipe_img
			return
		if area is PlatingJob:
			area.emit_signal("plating_complete")
			return
		if area.check_trigger(goblin):
			area.pre_job(goblin)
			if not area.pre_job_bool:
				await area.pre_job_done
			var b = JOB_PROGRESS.instantiate() as TextureProgressBar
			add_child(b)
			b.global_position = get_parent().global_position - Vector2(8, 24)
			area.dur_job(goblin)
			b.start(area.time)
			goblin.change_state("Working")
			play_random_animation()
			await get_tree().create_timer(area.time).timeout
			b.queue_free()
			area.post_job(goblin)
			if not area.post_job_bool:
				await area.post_job_done

func play_random_animation():
	var n = randi_range(0, 2)
	if n == 0: goblin.sprite.play("working_front")
	else: goblin.sprite.play("working_back")
