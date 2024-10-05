extends Node2D

class_name	AntSpawner

const AntPrefab = preload("res://ant.tscn")
@export var spawnTimeMin  = 2
@export var spawnTimeMax  = 2
@onready var enabled = true
var currTimer
signal reenabled

func _ready() -> void:
	while true:
		currTimer = get_tree().create_timer(randi_range(spawnTimeMin,spawnTimeMax))
		await currTimer.timeout
		if enabled:
			var ant = AntPrefab.instantiate()
			add_child(ant)
		else:
			await reenabled

func set_enabled(enabled : bool):
	self.enabled = enabled
	currTimer.stop()
	reenabled.emit()
