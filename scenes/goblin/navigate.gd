extends GoblinState

#goblin is the parent Goblin

signal navigate_process

var enable_process : bool = false
var rand_offset := Vector2.ZERO

func init():
	enable_process = true
	rand_offset = Vector2.from_angle(randf_range(0,2*PI))
	rand_offset *= randf_range(0,goblin.curr_target.scale.x * 10)
	goblin.highlight.color = Color.ROYAL_BLUE
	
func run():
	pass

func stop():
	enable_process = false
	
func _physics_process(delta):
	if enable_process:
		goblin.nav_agent.target_position = goblin.curr_target.global_position + rand_offset
		if goblin.nav_agent.is_navigation_finished():
			goblin.change_state("Idle")
			return
		var current_agent_position: Vector2 = goblin.global_position
		var next_path_position: Vector2 = goblin.nav_agent.get_next_path_position()

		goblin.velocity = current_agent_position.direction_to(next_path_position) * goblin.movement_speed
		goblin.move_and_slide()
