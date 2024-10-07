extends GoblinState

var enable_process : bool = false

func run():
	if goblin.item_holding == null:
		goblin.sprite.play("walking")
	else: goblin.sprite.play("walking_item")

func init():
	enable_process = true
	if goblin.item_holding == null:
		goblin.sprite.play("walking")
	else: goblin.sprite.play("walking_item")

func _process(delta):
	if goblin.nav_agent.is_navigation_finished():
		goblin.change_state("Idle")
		return

	var current_agent_position: Vector2 = goblin.global_position
	var next_path_position: Vector2 = goblin.nav_agent.get_next_path_position()

	goblin.velocity = current_agent_position.direction_to(next_path_position) * goblin.movement_speed
	goblin.sprite.scale.x = 1 if goblin.velocity.x > 0 else -1
	goblin.move_and_slide()
