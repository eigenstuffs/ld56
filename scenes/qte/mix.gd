class_name Mix extends Control

signal done
var result : String = ""

@export var length : int = 4
@export var combination : Array[String]

const ARROW = preload("res://scenes/qte/arrow.tscn")

@onready var arrows = $Arrows
@onready var timer : Timer = $Timer
@onready var audio = $AudioStreamPlayer2D
@export var win_sound : Resource
@export var press_sound : Resource
var pitches = [1,1.333,1.666,2]

func _ready():
	audio.stream = press_sound
	pitches.shuffle()
	generate_combination(length)
	timer.start(2.5)

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
				sprite.frame_coords = Vector2(0, 0)
			"down":
				sprite.frame_coords = Vector2(3, 0)
			"left":
				sprite.frame_coords = Vector2(2, 0)
			"right":
				sprite.frame_coords = Vector2(1, 0)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.is_action_pressed("up") and combination[0] == "up":
			audio.pitch_scale = pitches[0]
		elif event.is_action_pressed("down") and combination[0] == "down":
			audio.pitch_scale = pitches[1]
		elif event.is_action_pressed("right") and combination[0] == "right":
			audio.pitch_scale = pitches[2]
		elif event.is_action_pressed("left") and combination[0] == "left":
			audio.pitch_scale = pitches[3]
		else:
			lose_minigame()
			return
		remove_first()
		
func remove_first():
	timer.stop()
	timer.start(1)
	combination.remove_at(0)
	arrows.get_child(0).queue_free()
	if combination.size() == 0:
		win_minigame()
	else:
		audio.play()
		
func win_minigame():
	result = "win"
	done.emit()
	audio.stream = win_sound
	audio.pitch_scale = 1
	audio.play()

func lose_minigame():
	result = "lose"
	done.emit()

func _on_timer_timeout():
	lose_minigame()

func delete():
	if audio.playing:
		await audio.finished
	queue_free()
	
