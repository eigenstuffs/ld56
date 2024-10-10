extends GoblinState

class_name Navigate

@export var audio : Resource
var enable_process : bool = false

func run():
	if goblin.item_holding == null:
		goblin.sprite.play("walking")
	else: goblin.sprite.play("walking_item")

func stop():
	enable_process = false
	goblin.audio.stop()
	
func init():
	enable_process = true
	goblin.audio.stream = audio
	goblin.audio.play()
	if goblin.item_holding == null:
		goblin.sprite.play("walking")
	else: goblin.sprite.play("walking_item")

func _process(delta):
	if enable_process:
		if goblin.nav_agent.is_navigation_finished():
			print("navigate.gd")
			goblin.change_state("Idle")
			return
		var current_agent_position: Vector2 = goblin.global_position
		var next_path_position: Vector2 = goblin.nav_agent.get_next_path_position()

		goblin.velocity = current_agent_position.direction_to(next_path_position) * goblin.movement_speed
		goblin.sprite.scale.x = 1 if goblin.velocity.x > 0 else -1
		goblin.move_and_slide()
