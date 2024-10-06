extends GoblinState

const JOB_PROGRESS : PackedScene = preload("res://scenes/goblin/job_progress.tscn")

func job(area : Job):
	area.goblins_engagaed += 1
	if area.goblins_engagaed >= area.goblins_needed:
		if area.items_needed.size() == 0 or goblin.item_holding in area.items_needed:
			if area.additional_conditions():
				if area.items_needed.size() > 0: #give the job its holding item
					area.item_reward = goblin.item_holding
					goblin.remove_item()
				if area.qte != null:
					var a = area.qte.instantiate() as Mix
					get_tree().current_scene.add_child(a)
					a.global_position = get_parent().global_position - Vector2(0, 16)
					await a.done
					if a.result == "lose":
						change_state("Eaten")
				var b = JOB_PROGRESS.instantiate() as TextureProgressBar
				add_child(b)
				b.global_position = get_parent().global_position - Vector2(8, 24)
				area.init()
				b.start(area.time)
				await get_tree().create_timer(area.time).timeout
				print("Done job")
				b.queue_free()
				goblin.hold_item(area.give_reward())
				change_state("JobDone")
				return
	change_state("Idle")
