extends Control

class_name ChoosingIngredient

@onready var sprites : Array[Sprite2D]= [$Sprite1, $Sprite2, $Sprite3]
var selection : Array[IngredientInfo] = [null, null, null]
var selected : IngredientInfo
@export var pick_from : Array[IngredientInfo]
var pick_from_left : Array[IngredientInfo]
var result
var goblin : GoblinBase
signal done

func _ready() -> void:
	selected = null
	print(goblin.state)
	repick()

func _process(delta: float) -> void:
	print(goblin.state)
	#goblin.state = GoblinBase.STATE.WORKING
	
func repick():
	for i in range(0,len(sprites)):
		if len(pick_from_left) == 0:
			pick_from_left = pick_from.duplicate()
		var index = randi_range(0,len(pick_from_left) - 1)
		sprites[i].texture = pick_from_left[index].sprite_upd
		selection[i] = pick_from_left.pop_at(index)

func _on_area_1_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	click_action(event, 0)

func _on_area_2_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	click_action(event, 1)

func _on_area_3_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	click_action(event, 2)

func _on_area_4_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("LMB"): repick()
	
func click_action(event : InputEvent, choice : int):
	if event.is_action_pressed("LMB"):
		selected = selection[choice]
		for sprite in sprites:
			sprite.queue_free()
		$Sprite4.queue_free()
		result = "done"
		done.emit()
