extends Node2D

var paused := false
var time = 0
# Called when the node enters the scene tree for the first time.

func _process(delta: float) -> void:
	if !paused: time += delta
