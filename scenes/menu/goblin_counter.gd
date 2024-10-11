extends Control

class_name GoblinCounter

const IDLE_STATES = [GoblinBase.STATE.IDLE, GoblinBase.STATE.AWAITING_INPUT]
var goblin_count: int = 0
@onready var title_label = $VBoxContainer/TitleLabel
@onready var count_label = $VBoxContainer/CountLabel
@onready var death_msgs = $DeathMessages

@export var death_msg_label : PackedScene

func _ready():
	title_label.text = "On Standby"
	update_goblin_count()
	
func update(state : int, prev_state : int):
	if state in IDLE_STATES:
		add_goblins(prev_state not in IDLE_STATES)
	elif prev_state in IDLE_STATES:
		remove_goblins(state not in IDLE_STATES)

func update_goblin_count():
	count_label.text = str(goblin_count)

func add_goblins(count: int):
	goblin_count += count
	update_goblin_count()

func remove_goblins(count: int = 1):
	goblin_count = max(goblin_count - count, 0)
	update_goblin_count()

func add_death_msg(gob : GoblinBase):
	var new_label : FadingDeathMsg = death_msg_label.instantiate()
	new_label.gob = gob
	death_msgs.add_child(new_label)
