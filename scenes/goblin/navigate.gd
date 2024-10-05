extends GoblinState

#goblin is the parent Goblin

signal navigate_process

var enable_process : bool = false

func init():
	enable_process = true
	goblin.highlight.color = Color.ROYAL_BLUE
	
func run():
	pass

func stop():
	enable_process = false
	goblin.highlight.color = Color.WHITE
	
func _physics_process(delta):
	if enable_process:
		if goblin.nav_agent.is_navigation_finished():
			goblin.change_state("Idle")
			return
		
		var current_agent_position: Vector2 = goblin.global_position
		var next_path_position: Vector2 = goblin.nav_agent.get_next_path_position()

		goblin.velocity = current_agent_position.direction_to(next_path_position) * goblin.movement_speed
		goblin.move_and_slide()
