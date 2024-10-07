extends Node

func _ready():
	print("start")
	if !Utilities.first_launch:
		queue_free()
	else:
		print("going")
		get_tree().paused = true
		await get_tree().create_timer(0.1).timeout
		Utilities.first_launch = false
		Utilities.dialogue(
			[
				"Goblin: 'Aye you there!'",
				"Goblin: 'We have been waiting all morning! Make haste, our dark overlord will soon wake.'",
				"Goblin: 'We must prepare a meal befitting His Darkness and his mighty station.'",
				"Goblin: 'Behold! A tome of great magicks. We call it.'",
				"Goblin: 'Eggs.'",
				"Welcome to Gobblin' Goblin! These goblins want to prepare food for their goblin overlord, and they need your help.",
				"Step 1: Get your ingredients: To move a goblin, click on a goblin in the standby area, and click again the ingredient you want them to get.",
				"Be sure to click finish as soon as the task timer runs out, lest you lose your ingredient and that goblin be banished! After all, nobody likes a slacker.",
				"Step 2: Prepare your ingredients",
				"Step 3: Cook the food. Bring all ingredients to Chef Gazpacho. Copy his movements exactly, or risk spoiling the whole dish.",
				"Step 4: Plate your food. You will require the strength of ALL your goblins to carry the dish with care!",
				"One final warning…a shadow grows in the East. When the feathered beast appears to pilfer your ingredients, three goblins are required to defend the kitchen. Act quickly!",
				"Good luck, traveler. Bring glory to the goblin kitchen!"
			],
			false
		)
	get_tree().paused = false
