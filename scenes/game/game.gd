extends Node2D

var paused := false
var time = 0
@export var gob_folder : Node2D
@export var progress_bar : ProgressBar
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	for gob in gob_folder.get_children():
		gob.connect("item_holding", update_progress)

func _process(delta: float) -> void:
	if !paused: time += delta

func update_progress(stuff):
	pass
	
