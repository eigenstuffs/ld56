extends Job

class_name PlatingJob

signal plating_complete

func init():
	item_reward = null

func give_reward():
	plating_complete.emit()
	print("completed!")
	return null
