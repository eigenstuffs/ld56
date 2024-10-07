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
signal state_changed(state : int, prev_state : int, item_holding)
signal update_progress(stuff)

@onready var ingredient : Recipe = preload("res://scenes/tools/recipes/all_ingredients.tres")
@onready var notice : Texture = preload("res://assets/ingredients/notice.png")
@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var item : Sprite2D = $Item
@export var gob_name := ""
@export var movement_speed : float = 100
var clicked : bool = false
var state := STATE.IDLE
var current_state_child
var curr_target : Goal = null
var item_holding = null

func _ready():
	change_state("Idle")
	$Name.text = "[center]" + gob_name
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
	emit_signal("state_changed", target_state, state, item_holding)
	state = target_state
	find_child(to).init()
	current_state_child = find_child(to)

func _on_goblin_hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent() is GoblinBase:
		if state == STATE.NAVIGATE and randf() < 0.3:
			if area.get_parent().state == STATE.NAVIGATE:
				change_state("Stunned")
				area.get_parent().change_state("Stunned")
	if area is Job:
		change_state("Working")
		$Working.job(area)
		# job done

func _on_goblin_hitbox_input_event(viewport, event, shape_idx):
	get_viewport().set_input_as_handled()
	if event.is_action_pressed("LMB") and (state == STATE.IDLE or state == STATE.AWAITING_INPUT):
		clicked = !clicked
		change_state("AwaitingInput" if clicked else "Idle")
		print(item_holding)
		if clicked: emit_signal("listening_for_target")

func hold_item(stuff):
	if stuff is IngredientInfo:
		item_holding = stuff
		item.texture = item_holding.get_current_sprite()
		emit_signal("update_progress", item_holding)
	elif stuff is Recipe:
		item_holding = stuff
		item.texture = item_holding.recipe_img

func set_target_pos(pos : Vector2):
	var obj : Goal = Goal.new()
	obj.global_position = pos
	obj.scale = Vector2(1, 1)
	obj.target_node = obj
	set_movement_target(obj)
	
func set_movement_target(target_goal):
	curr_target = target_goal
	nav_agent.target_position = target_goal.target_node.global_position
	if nav_agent.is_navigation_finished():
		target_goal._on_area_entered($Goblin_hitbox)
	else:
		change_state("Navigate")

func remove_item():
	item_holding = null
	item.texture = null
