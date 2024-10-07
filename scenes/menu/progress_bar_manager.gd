extends NinePatchRect

class_name ProgressBarManager

var task_list : TaskList = preload("res://scenes/tools/task/task_list.tres")

func _ready():
	for index in range(get_child_count()):
		var progress_bar = get_child(index)
		progress_bar.max_value = 1
		progress_bar.value = 0
		print("Task: ", task_list.task_array[index].task_name)

func update_prep_progress(val : int = 1, max : int = -1, add : bool = false):
		update_progress_bar(0, val, max, add)

func update_cooking_progress(val : int = 1, max : int = -1, add : bool = false):
		update_progress_bar(1, val, max, add)

func update_def_progress(val : int = 1, max : int = -1, add : bool = false):
	if max == 0:
		get_child(2).max_value = 1
		get_child(2).value = 1
		get_child(2).modulate = Color.GRAY
	else:
		update_progress_bar(2, val, max, add)

func update_progress_bar(child_index, val, max, add : bool):
	if max > 0: get_child(child_index).max_value = max
	val += get_child(child_index).value if add else 0
	get_child(child_index).value = min(val, get_child(child_index).max_value)
