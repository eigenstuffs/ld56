extends Node2D
class_name Game
var time = 0
@export var gob_folder : Node2D
@export var progress_bar : ProgressBarManager
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	for gob in gob_folder.get_children():
		gob.connect("update_progress", update_progress)

func _process(delta: float) -> void:
	if !get_tree().paused: time += delta

func update_progress(stuff):
	if stuff is IngredientInfo:
		var ing : IngredientInfo = stuff
		progress_bar.update_prep_progress(ing.processed())
	elif stuff is Recipe:
		var rec : Recipe = stuff
		progress_bar.update_cooking_progress()
