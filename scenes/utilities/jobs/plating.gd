extends Job

class_name PlatingJob

signal plating_complete(plate)

func pre_job(gob : GoblinBase):
	item_reward = gob.item_holding
	gob.remove_item()
	finish_pre_job()

func check_trigger(gob : GoblinBase) -> bool:
	return gob.item_holding is Recipe

func give_reward():
	emit_signal("plating_complete", item_reward)
	return null
