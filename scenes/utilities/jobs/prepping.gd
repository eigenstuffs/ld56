extends Job

class_name PreppingJob

func give_reward():
	if item_reward == null:
		return null
	item_reward.state = 1 #flip it to processed
	return item_reward
