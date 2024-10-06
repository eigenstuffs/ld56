extends Camera2D

@export var move_speed := 1
var cam_height : int
var movable : bool = true

func _ready():
	limit_top = $TopLeft.position.y
	limit_bottom = $BottomRight.position.y
	cam_height = get_viewport().get_visible_rect().size.y/2

func _process(delta):
	if movable:
		var view_size = get_viewport().get_visible_rect().size
		var mouse_pos = get_viewport().get_mouse_position()
		if mouse_pos.y < view_size.y * 0.1:
			position.y -= move_speed
		elif mouse_pos.y > view_size.y * 0.9:
			position.y += move_speed
			
	position.y = clamp(position.y, limit_top+cam_height, limit_bottom-cam_height)
