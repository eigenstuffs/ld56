extends GoblinState

class_name Stunned
#goblin is the parent Goblin
@export var stun_time := 0.5
@export var immune_time := 0.5
var enable_process : bool = false

@export var audio : Resource

func init():
	enable_process = true
	goblin.modulate = Color.YELLOW
	goblin.audio.stream = audio
	goblin.audio.play()
	get_parent().set_collision_mask(2)
	await get_tree().create_timer(stun_time).timeout
	goblin.change_state("Navigate")
	await get_tree().create_timer(immune_time).timeout
	get_parent().set_collision_mask(1)
	
func run():
	pass
