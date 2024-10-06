extends Camera2D

const CAMERA_HEIGHT = 90

var movable : bool = true

func _ready():
	limit_top = $TopLeft.position.y

	limit_bottom = $BottomRight.position.y

func _process(delta):
	if movable:
		if Input.is_action_pressed("down"):
			position.y += 1
		elif Input.is_action_pressed("up"):
			position.y -= 1
		
	position.y = clamp(position.y, limit_top+CAMERA_HEIGHT, limit_bottom-CAMERA_HEIGHT)
