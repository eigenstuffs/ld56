extends Node

const DIALOGUE : PackedScene = preload("res://scenes/utilities/dialogue.tscn")

func dialogue(text : Array[String], bars : bool = true):
	if bars:
		GlobalAnim.bars_down()
		await GlobalAnim.anim_done
	var a = DIALOGUE.instantiate() as Dialogue
	get_tree().current_scene.add_child(a)
	a.text = text
	a.start()
	await a.done
	a.queue_free()
	if bars:
		GlobalAnim.bars_up()
