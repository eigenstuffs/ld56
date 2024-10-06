extends CharacterBody2D

class_name GoblinBase

enum STATE {
	IDLE,
	STUNNED,
	NAVIGATE,
	WORKING,
	AWAITING_INPUT,
	EATEN,
	EXPLODE
}

signal listening_for_target

@onready var nav_agent = $NavigationAgent2D
@onready var highlight : ColorRect = $Highlight #TODO temporary
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

@export var movement_speed : float = 100
var clicked : bool = false
var state := STATE.IDLE
var current_state_child
var curr_target : Goal = null

func _ready():
	change_state("Idle")
	
	actor_setup.call_deferred()
	
func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

func change_state(to : String):
	if current_state_child != null and current_state_child is GoblinState:
		current_state_child.stop()
	set_collision_layer(1)
	set_collision_mask(1)
	var target_state
	match to:
		"Idle":
			target_state = STATE.IDLE
		"Stunned":
			target_state = STATE.STUNNED
			$Navigate.stop()
		"Navigate":
			target_state = STATE.NAVIGATE
		"Working":
			target_state = STATE.WORKING
		"AwaitingInput":
			target_state = STATE.AWAITING_INPUT
		"Eaten":
			target_state = STATE.EATEN
		"Explode":
			target_state = STATE.EXPLODE
	state = target_state
	find_child(to).init()
	current_state_child = find_child(to)

func set_movement_target(movement_target : Goal):
	curr_target = movement_target
	change_state("Navigate")

func set_target_pos(target_pos : Vector2):
	var obj = Goal.new()
	obj.global_position = target_pos
	obj.scale = Vector2(1,1)
	set_movement_target(obj)

func _on_goblin_hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent() is GoblinBase:
		if state == STATE.NAVIGATE and area.get_parent().state == STATE.NAVIGATE:
			change_state("Stunned")
			area.get_parent().change_state("Stunned")

func _on_goblin_hitbox_input_event(viewport, event, shape_idx):
	get_viewport().set_input_as_handled()
	if event.is_action_pressed("LMB") and (state == STATE.IDLE or state == STATE.AWAITING_INPUT):
		clicked = !clicked
		change_state("AwaitingInput" if clicked else "Idle")
		if clicked: emit_signal("listening_for_target")
