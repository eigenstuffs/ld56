extends Control

const SELECTED_SFX = preload("res://assets/sfx/Copy of Menu_Sounds_V2_Minimalistic_FORWARD.mp3")
func _on_play_pressed() -> void:
	$sfx.stream = SELECTED_SFX
	$sfx.play()
	await $sfx.finished
	get_tree().change_scene_to_file("res://scenes/game/level_1.tscn")

func _on_options_pressed() -> void:
	$sfx.stream = SELECTED_SFX
	$sfx.play()
	await $sfx.finished
	get_tree().change_scene_to_file("res://scenes/menu/Credits.tscn")

func _on_quit_pressed() -> void:
	$sfx.stream = SELECTED_SFX
	$sfx.play()
	await $sfx.finished
	get_tree().quit()
