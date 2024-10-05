extends CharacterBody2D
#thanks oscar for the code
class_name Ant

@export var speed : float = 5
@export var eat_time: float = 5
var nav_agent

func _ready():
	global_position = Vector2([-30,get_viewport().size.x + 30].pick_random(), get_viewport().size.y)
	global_position = Vector2.ZERO
	actor_setup.call_deferred()

func actor_setup():
	await get_tree().physics_frame
	nav_agent = $navAgent
	retarget()

func retarget():
	nav_agent.target_position = Vector2(-100,-50)
	print("set target")
	########### idk what the targets are yet.... stored food? goblins? 

func _physics_process(delta):
	if nav_agent.is_navigation_finished():
		eat()
	velocity = global_position.direction_to(Vector2(100,50))
	velocity *= speed
	move_and_slide()
	
func eat():
	await get_tree().create_timer(eat_time).timeout
	retarget()
