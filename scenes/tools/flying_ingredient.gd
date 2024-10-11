extends CharacterBody2D

class_name FlyingIngredient

var target_pos : Vector2
var ingredient : IngredientInfo
var recipe : Recipe
var accel : float

# Called when the node enters the scene tree for the first time.
func init(bird : Bird_Window, item, progList : ProgressBarManager, recList : Recipe_Display) -> void:
	if item is IngredientInfo:
		global_position = recList.global_position
	else:
		global_position = progList.global_position
	accel = randf()
	target_pos = bird.global_position
	var angle = get_angle_to(target_pos) - PI * randf_range(5/6, 7/6)
	velocity = Vector2.from_angle(angle) * randf_range(5,10)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
