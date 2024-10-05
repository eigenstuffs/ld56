extends CharacterBody2D
#thanks oscar for the code
class_name Ant

@export var speed : float = 100
@export var eat_time: float = 5
var nav_agent

enum STATE {
	NAVIGATE,
	EATING,
	DEATH
}
var state := STATE.NAVIGATE

func _ready():
	global_position = Vector2([-30,get_viewport().size.x + 30].pick_random(), get_viewport().size.y)
	global_position = Vector2.ZERO
	nav_agent = $navAgent
	after_ready.call_deferred()
	
func after_ready():
	await get_tree().physics_frame

func retarget():
	state = STATE.NAVIGATE
	nav_agent.target_position = get_global_mouse_position()
	print("set target")
	########### idk what the targets are yet.... stored food? goblins? 

func _physics_process(delta: float) -> void:
	if state == STATE.NAVIGATE:
		if nav_agent.is_navigation_finished():
			eat()
		else:
			var current_agent_position: Vector2 = global_position
			var next_path_position: Vector2 = nav_agent.get_next_path_position()
			velocity = current_agent_position.direction_to(next_path_position) * speed
			move_and_slide()
	
func eat():
	state = STATE.EATING
	await get_tree().create_timer(eat_time).timeout
	retarget()
