extends Job

class_name PlatingJob

signal plating_complete

func pre_job(gob : GoblinBase):
	item_reward = gob.item_holding
	time = item_reward.prep_time
	gob.remove_item()
	finish_pre_job()

func check_trigger(gob : GoblinBase) -> bool:
	return gob.item_holding is Recipe

func give_reward():
	plating_complete.emit()
	print("completed!")
	return null
