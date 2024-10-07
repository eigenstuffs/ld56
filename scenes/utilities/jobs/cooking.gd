extends Job

class_name CookingJob

var product : Recipe
@export var ingredient_gathered = []
var ing_gathered := {}
@export var cook_time : int = 8
@export var drop_time : int = 2
signal ing_recieved(ing)

func _ready() -> void:
	time = drop_time
	
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
