extends RichTextLabel

class_name FadingDeathMsg

@onready var timer = $Timer
var gob : GoblinBase

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "[center]" + gob.gob_name + " " + gob.death_message
	for i in range(0, 100, 5):
		modulate.a = i/100.0
		timer.start(0.02)
		await timer.timeout
	modulate.a = 1
	timer.start(2)
	await timer.timeout
	for i in range(100, 0, -2):
		modulate.a = i/100.0
		timer.start(0.02)
		await timer.timeout
	modulate.a = 0
	var start_height = size.y
	fit_content = false
	for i in range(20, 0, -1):
		custom_minimum_size.y = start_height * i / 20.0
		timer.start(0.05)
		await timer.timeout
	queue_free()
