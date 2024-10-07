extends Job

class_name PreppingJob

func pre_job(gob : GoblinBase):
	if gob.item_holding in items_needed:
		item_reward = gob.item_holding
		gob.remove_item()
	job_done.emit()

func give_reward():
	if item_reward == null:
		return null
	item_reward.state = 1 #flip it to processed
	return item_reward
