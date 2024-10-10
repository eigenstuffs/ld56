extends Control

class_name CollectionTask

var goblin : GoblinBase
var result
signal done
@onready var audio := $AudioStreamPlayer2D
@export var begin_sound : Resource
@export var collect_sound : Resource
	
func _ready() -> void:
	audio.stream = begin_sound
	audio.play()
	goblin.connect("clicked_on", end_timer)
	$Timer.start(5)

func _on_timer_timeout():
	result = "lose"
	done.emit()

func end_timer():
	$Timer.stop()
	result = "win"
	audio.stream = collect_sound
	audio.play()
	done.emit()

func delete():
	if audio.playing:
		await audio.finished
	queue_free()
