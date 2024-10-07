extends Job

class_name CookingJob

@export var product : Recipe
@export var ingredient_gathered = []
var ing_gathered := {}
@export var cook_time : int = 8
@export var drop_time : int = 0
signal ing_recieved(ing)

func prejob(gob : GoblinBase):
	if gob.item_holding in items_needed:
		ingredient_gathered.append(gob.item_holding)
		gob.remove_item()
	var count : int = 0
	for item in items_needed:
		if item in ingredient_gathered:
			count += 1
	if count >= items_needed.size():
		item_reward = product
		time = cook_time
	else: time = drop_time
	pre_job_done.emit()
	
func init():
	if item_reward != null:
		emit_signal("ing_recieved", item_reward)
		item_reward = null

func give_reward():
	var prod = product
	product = null
	time = drop_time
	return prod
	
func start_cooking(rec : Recipe):
	product = rec
	time = cook_time
