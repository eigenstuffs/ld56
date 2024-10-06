extends Camera2D

const CAMERA_HEIGHT = 90

var movable : bool = true

func _ready():
	limit_top = $TopLeft.position.y
	limit_bottom = $BottomRight.position.y

func _process(delta):
	if movable:
		var view_size = get_viewport().get_visible_rect().size
		var mouse_pos = get_viewport().get_mouse_position()
		if mouse_pos.y < view_size.y * 0.1:
			position.y -= 1
		elif mouse_pos.y > view_size.y * 0.9:
			position.y += 1
			
	position.y = clamp(position.y, limit_top+CAMERA_HEIGHT, limit_bottom-CAMERA_HEIGHT)
