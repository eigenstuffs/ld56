extends Control

var task_list : TaskList = preload("res://scenes/tools/task/task_list.tres")

func _ready():
	for index in range(get_child_count()):
		get_child(index).value = task_list.task_array[index].total_time
		print(task_list.task_array[index].total_time)


#issue is logic- look at tomorrow when awake
