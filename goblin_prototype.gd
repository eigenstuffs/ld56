extends CharacterBody2D

class_name Goblin

signal listening_for_target

@onready var nav_agent = $NavigationAgent2D

var movement_speed : float = 300
var clicked : bool = false

func _ready():
	
	actor_setup.call_deferred()

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

func set_movement_target(movement_target : Vector2):
	nav_agent.target_position = movement_target

func _physics_process(delta):
	
	if nav_agent.is_navigation_finished():
		return
	
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = nav_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()

func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("LMB"):
		clicked = true
		print("you clicked on this character!")
		emit_signal("listening_for_target")

func set_target():
	pass
