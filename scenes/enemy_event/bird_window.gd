class_name Bird_Window extends Goal

@export var birdImages : Array[Texture] = []
@onready var sprite = $Sprite
@onready var progress_bar = $CountdownBar
@onready var abort_button := $AbortButton
@onready var timer = $Timer
var countdown = 0
var goblins : Array[GoblinBase] = []
@export var max_birds = 1
@export var min_time = 5
@export var max_time = 10
@export var garrison_point : Goal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_node = garrison_point
	garrison_point.connect("entered", add_gob)
	while true:
		progress_bar.value = 0
		progress_bar.modulate = Color.GRAY
		sprite.texture = birdImages[0]
		await get_tree().create_timer(randi_range(min_time,max_time)).timeout
		var numBirds = randi_range(1,max_birds)
		progress_bar.modulate = Color.WHITE
		sprite.texture = birdImages[numBirds]
		timer.stop()
		for i in range(0,15):
			progress_bar.value = 15 - i
			timer.start(1)
			await timer.timeout
		if len(goblins) < numBirds * 3:
			clear_gobs(true)
			#TODO switch animation player to birds eating
		else:
			clear_gobs(false)
			#TODO switch animation player to birds running away
		
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
		await get_tree().create_timer(0.1 if killed else 0.5).timeout

func _on_abort_button_pressed() -> void:
	abort_button.disabled = true
	abort_button.text = "Fleeing..."
	await get_tree().create_timer(2).timeout
	clear_gobs(false)
	abort_button.text = "Flee"

func add_gob(goblin : GoblinBase):
	print("recieved")
	abort_button.disabled = len(goblins) > 0 && abort_button.disabled
	goblins.append(goblin)
	goblin.visible = false
