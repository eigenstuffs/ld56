extends Job

class_name PreppingJob

@export var collectTask : PackedScene

func pre_job(gob : GoblinBase):
	play_random_animation(gob)
	item_reward = gob.item_holding
	time = item_reward.prep_time
	gob.remove_item()
	finish_pre_job()

func post_job(gob : GoblinBase):
	if item_reward.state == 1:
		gob.death_message = death_msg(item_reward).pick_random()
		gob.change_state("Explode")
		return
	var task : CollectionTask = collectTask.instantiate()
	task.goblin = gob
	gob.add_child(task)
	task.global_position = gob.global_position
	await task.done
	if(task.result == "lose"):
		gob.death_message = death_msg(item_reward).pick_random()
		print(gob.death_message)
		gob.change_state("Explode")
	else:
		gob.hold_item(give_reward())
		print("prepping.gd")
		gob.change_state("Idle")
		finish_post_job()
	task.delete()

func check_trigger(gob : GoblinBase) -> bool:
	return gob.item_holding is IngredientInfo

func death_msg(item : IngredientInfo) -> Array[String]:
	print(item.ing_name)
	match item.ing_name.to_lower():
		"egg" : return ["made a merengue at the wrong time", "got carpal tunnel from whisking", \
			"thought the shell was the edible part", "failed to make an eggcellent pun"]
		"veggie" : return ["cut the brocolli too small", "destroyed Dave's favorite veggies", \
			"cut their fingers instead brocolli", "attempted to make baby food"]
		"sugar" : return ["poured too much sugar", "learned about diabetes", \
			"mixed up salt for sugar", "accidentally made rock candy"]
		"meat" : return ["got sick from salmonella", "wanted to try green ham", \
			"turned prime grade beef into jerky", "cut the meet with the grain"]
		"secret ingredient" : return ["died from mysterious effects", "tried to develop immunity to poison", \
			"tried to make a love potion", "asked what the secret was"]
		"spices" : return ["cooked the flavor out of the spices", "tried to remove all the seeds", \
			"sneezed due to pepper powder", "developed chemical burns from pepper oil"]
		"flour" : return ["made hardtack at the wrong time", "made flatbread at the wrong time", \
			"made biscuits at the wrong time", "made pancakes at the wrong time"]
		_: return ["asdf"]
