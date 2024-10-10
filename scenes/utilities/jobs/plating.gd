extends Job

class_name PlatingJob

func pre_job(gob : GoblinBase):
	gob.remove_item()
	play_random_animation(gob)
	finish_pre_job()

func post_job(gob : GoblinBase):
	gob.emit_signal("plate_delivered", gob.item_holding)
	gob.change_state("Idle")
	finish_post_job()

func check_trigger(gob : GoblinBase) -> bool:
	return gob.item_holding is Recipe

func give_reward():
	return null
