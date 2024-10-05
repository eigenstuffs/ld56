extends GoblinState

#goblin is the parent Goblin
@export var stun_time := 2.0
@export var immune_time := 0.1
var enable_process : bool = false

func init():
	enable_process = true
	goblin.highlight.color = Color.WHITE
	get_parent().set_collision_mask(2)
	await get_tree().create_timer(stun_time).timeout
	goblin.change_state("Navigate")
	await get_tree().create_timer(immune_time).timeout
	get_parent().set_collision_mask(1)
	
func run():
	pass
