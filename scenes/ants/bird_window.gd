class_name Bird_Window extends Goal

@onready var ani_player = $AnimationPlayer
@onready var goblin_text = $GoblinCount
@onready var count_text = $Countdown
@onready var abort_button := $AbortButton
var countdown = 0
var goblins : Array[GoblinBase] = []
@export var num_birds = 1
@export var min_time = 5
@export var max_time = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	while true:
		countdown = 0
		count_text.visible = false
		$ColorRect.color = Color.BLACK
		#TODO burdless sprite animation
		await get_tree().create_timer(randi_range(min_time,max_time)).timeout
		$ColorRect.color = Color.RED
		count_text.visible = true
		for i in range(0,15):
			countdown = 15 - i
			count_text.text = "[right]" + str(countdown)
			await get_tree().create_timer(1).timeout
		if len(goblins) < num_birds * 3:
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
		goblin_text.text = "Garrisoned Goblins: " + str(len(goblins))
		if(killed):
			gob.change_state("Eaten")
		else:
			gob.visible = true
			gob.set_target_pos(Vector2.ZERO) #TODO idk where the spawn is or where to return to	
		await get_tree().create_timer(0.1 if killed else 0.5).timeout

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is GoblinBase:
		abort_button.disabled = len(goblins) > 0 && !abort_button.disabled
		var gob = area.get_parent()
		goblins.append(gob)
		gob.visible = false
		goblin_text.text = "Garrisoned Goblins: " + str(len(goblins))

func _on_abort_button_pressed() -> void:
	abort_button.disabled = true
	await get_tree().create_timer(2).timeout
	clear_gobs(false)
