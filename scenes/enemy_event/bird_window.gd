class_name Bird_Window extends Goal

@export var birdImages : Array[Texture] = []
@export var alarm_sound : Resource
@export var chirp_sound : Resource
@export var flee_sound : Resource
@onready var audio = $AudioStreamPlayer
@onready var sprite = $Sprite
@onready var progress_bar = $CountdownBar
@onready var abort_button := $AbortButton
@onready var timer = $Timer
var countdown = 0
var goblins : Array[GoblinBase] = []
@export var max_birds = 1
var num_birds = 0
@export var min_time = 30
@export var max_time = 40
@export var garrison_time = 30
@export var garrison_point : Goal
var def_success : bool = false
signal gobs_changed
signal def_failed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_node = garrison_point
	progress_bar.max_value = garrison_time
	garrison_point.connect("entered", add_gob)
	while true:
		num_birds = 0
		emit_signal("gobs_changed")
		progress_bar.value = 0
		sprite.texture = birdImages[0]
		timer.start(randi_range(min_time, max_time) * (2 if def_success else 1))
		await timer.timeout
		audio.stream = alarm_sound
		audio.play()
		num_birds = randi_range(1,max_birds)
		emit_signal("gobs_changed")
		progress_bar.max_value = garrison_time
		sprite.texture = birdImages[num_birds]
		timer.stop()
		for i in range(0,garrison_time):
			progress_bar.value = garrison_time - i
			timer.start(1)
			await timer.timeout
		def_success = len(goblins) >= num_birds * 3
		if def_success:
			audio.stream = chirp_sound
			audio.play()
			clear_gobs(false)
			#TODO switch animation player to birds running away
		else:
			emit_signal("def_failed")
			audio.stream = chirp_sound
			audio.play()
			clear_gobs(true)
			#TODO switch animation player to birds eating

func clear_gobs(killed : bool):
	abort_button.disabled = true
	while len(goblins)>0:
		var gob = goblins[0]
		goblins = goblins.slice(1)
		if(killed):
			gob.change_state("Eaten")
		else:
			gob.visible = true
			gob.set_target_pos(garrison_point.global_position)
		emit_signal("gobs_changed")
		await get_tree().create_timer(0.1 if killed else 0.5).timeout

func _on_abort_button_pressed() -> void:
	abort_button.disabled = true
	abort_button.text = "Fleeing..."
	audio.stream = flee_sound
	audio.play()
	await get_tree().create_timer(2).timeout
	clear_gobs(false)
	abort_button.text = "Flee"

func add_gob(goblin : GoblinBase):
	if goblin.curr_target == garrison_point:
		abort_button.disabled = len(goblins) > 0 && abort_button.disabled
		goblins.append(goblin)
		goblin.visible = false
		emit_signal("gobs_changed")
