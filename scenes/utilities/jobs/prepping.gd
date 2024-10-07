extends Job

class_name PreppingJob

func pre_job(gob : GoblinBase):
	item_reward = gob.item_holding
	time = item_reward.prep_time
	gob.remove_item()
	finish_pre_job()

func post_job(gob : GoblinBase):
	super(gob)

func check_trigger(gob : GoblinBase) -> bool:
	return gob.item_holding is IngredientInfo and gob.item_holding.state == 0
