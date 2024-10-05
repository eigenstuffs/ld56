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
@onready var highlight : ColorRect = $Highlight #TODO temporary

var movement_speed : float = 300
var clicked : bool = false
var state := STATE.IDLE
var current_state_child

func _ready():
	change_state("Idle")
	
	actor_setup.call_deferred()
	
func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

func change_state(to : String):
	if current_state_child != null and current_state_child is GoblinState:
		current_state_child.stop()
	var target_state
	match to:
		"Idle":
			target_state = STATE.IDLE
		"Navigate":
			target_state = STATE.NAVIGATE
		"Working":
			target_state = STATE.WORKING
		"AwaitingInput":
			target_state = STATE.AWAITING_INPUT
		"Explode":
			target_state = STATE.EXPLODE
	state = target_state
	find_child(to).init()
	current_state_child = find_child(to)

func set_movement_target(movement_target : Vector2):
	nav_agent.target_position = movement_target
	change_state("Navigate")

func _on_clickable_region_gui_input(event):
	if event.is_action_pressed("LMB"):
		clicked = true
		change_state("AwaitingInput")
		#print("you clicked on this character!") #TODO remove this
		emit_signal("listening_for_target")

#Helper function called by different states
