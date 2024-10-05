class_name Mix extends Control

@export var length : int = 4
@export var combination : Array[String]

func _ready():
	generate_combination(length)

func generate_combination(length : int):
	for i in length:
		var input : String
		match randi_range(1, 4):
			1:
				input = "up"
			2:
				input = "down"
			3:
				input = "left"
			4:
				input = "right"
		combination.append(input)

