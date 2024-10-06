extends NinePatchRect

var task_list : TaskList = preload("res://scenes/tools/task/task_list.tres")

var has_found_all_ingredients = false
var has_cooked_all_objects = false
var has_defeated_all_enemies = false

func _ready():
	for index in range(get_child_count()):
		var progress_bar = get_child(index)
		progress_bar.max_value = 100
		progress_bar.value = 0
		print("Task: ", task_list.task_array[index].task_name)

func _process(delta):
	update_prep_progress()
	update_cooking_progress()
	update_def_progress()

func update_prep_progress():
	var prep_pb = get_child(0)
	if has_found_all_ingredients:
		prep_pb.value = 100
	else:
		prep_pb.value = calculate_prep_progress()

func update_cooking_progress():
	var cooking_pb = get_child(1)
	if has_cooked_all_objects:
		cooking_pb.value = 100
	else:
		cooking_pb.value = calculate_cooking_progress()

func update_def_progress():
	var def_pb = get_child(2)
	if has_defeated_all_enemies:
		def_pb.value = 100
	else:
		def_pb.value = calculate_def_progress()

#Gibberish, replace with game logic
func calculate_prep_progress():
	return 50 

func calculate_cooking_progress():
	return 30 

func calculate_def_progress():
	return 20 
