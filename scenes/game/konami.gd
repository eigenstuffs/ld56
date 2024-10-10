extends Node2D

class_name KonamiCode

@export var code : Array[String] = ["Up", "Up", "Down", "Down", \
	"Left", "Right", "Left", "Right", "D", "A", "V", "E", "Enter"]
var keyCodes : Array
var index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for key in code:
		keyCodes.append(OS.find_keycode_from_string(key))
	print(keyCodes)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent) -> void:
	if index < len(keyCodes) and event is InputEventKey and event.pressed:
		var keyEvent : InputEventKey = event
		if keyEvent.keycode == keyCodes[index]: index += 1
		else: index = 1 if keyEvent.keycode == keyCodes[0] else 0
		if index >= len(keyCodes):
			$LevelScene.time = 0
			$LevelScene.level_end()
		print(index)
