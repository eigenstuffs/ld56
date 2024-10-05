extends CharacterBody2D

class_name GoblinBase

enum STATE {
	IDLE,
	NAVIGATE,
	WORKING,
	AWAITING_INPUT,
	EXPLODE
}

signal listening_for_target

@onready var nav_agent = $NavigationAgent2D

var movement_speed : float = 300
var clicked : bool = false
var state := STATE.IDLE

func _ready():
	
	actor_setup.call_deferred()
	
func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

func _process(delta):
	#find_child(state).run()
	
	if clicked:
		$Highlight.show()
	else: $Highlight.hide()

func change_state(to : String):
	var target_state
	match to:
		"Idle":
			target_state = STATE.IDLE
		"Navigate":
			target_state = STATE.NAVIGATE
		"Working":
			target_state = STATE.WORKING
		"AwaitInput":
			target_state = STATE.AWAITING_INPUT
		"Explode":
			target_state = STATE.EXPLODE
	state = target_state
	find_child(to).init()

func set_movement_target(movement_target : Vector2):
	nav_agent.target_position = movement_target
	state = 1 #navigate

func _physics_process(delta):
	if state == STATE.NAVIGATE:
		if nav_agent.is_navigation_finished():
			state = STATE.IDLE #idle
			return
		
		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = nav_agent.get_next_path_position()

		velocity = current_agent_position.direction_to(next_path_position) * movement_speed
		move_and_slide()

func _on_clickable_region_gui_input(event):
	if event.is_action_pressed("LMB"):
		clicked = true
		print("you clicked on this character!") #TODO remove this
		emit_signal("listening_for_target")
