extends Camera2D

func _ready():
	limit_top = $TopLeft.position.y

	limit_bottom = $BottomRight.position.y

func _process(delta):
	if Input.is_action_pressed("down"):
		position.y += 1
	elif Input.is_action_pressed("up"):
		position.y -= 1
