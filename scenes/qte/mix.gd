class_name Mix extends Control

@export var length : int = 4
@export var combination : Array[String]

const ARROW = preload("res://assets/arrow.tscn")

@onready var arrows = $Arrows

func _ready():
	generate_combination(length)

func generate_combination(len : int):
	for i in len:
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
		
	create_icons()

func create_icons():
	for i in combination:
		var a = ARROW.instantiate()
		arrows.add_child(a)
		var sprite = a.find_child("Sprite") as Sprite2D
		match i:
			"up":
				sprite.frame_coords = Vector2(0, 1)
			"down":
				sprite.frame_coords = Vector2(3, 1)
			"left":
				sprite.frame_coords = Vector2(2, 1)
			"right":
				sprite.frame_coords = Vector2(1, 1)
