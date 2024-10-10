extends Control

class_name ChoosingIngredient

@export var audio_repick : Resource
@export var audio_choose : Resource

@onready var audio = $AudioStreamPlayer
@onready var sprites : Array[Sprite2D]= [$Sprite1, $Sprite2, $Sprite3]
var selection : Array[IngredientInfo] = [null, null, null]
var selected : IngredientInfo
var pick_from : Array[IngredientInfo]
var result
var goblin : GoblinBase
signal done

func _ready() -> void:
	selected = null
	repick()
	
func repick():
	pick_from.shuffle()
	var index = 0
	for i in range(0,len(sprites)):
		index = i % len(pick_from)
		sprites[i].texture = pick_from[index].sprite_upd
		selection[i] = pick_from[index]

func _on_area_1_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	click_action(event, 0)

func _on_area_2_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	click_action(event, 1)

func _on_area_3_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	click_action(event, 2)

func _on_area_4_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("LMB"):
		repick()
		audio.stream = audio_repick
		audio.play()
	
func click_action(event : InputEvent, choice : int):
	if event.is_action_pressed("LMB"):
		audio.stream = audio_choose
		audio.play()
		selected = selection[choice]
		for sprite in sprites:
			sprite.queue_free()
		$Sprite4.queue_free()
		result = "done"
		done.emit()

func delete():
	if audio.playing:
		await audio.finished
	queue_free()
