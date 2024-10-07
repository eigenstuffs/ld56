extends Job

class_name PreppingJob

func give_reward():
	item_reward.state = 1 #flip it to processed
	return item_reward
