extends Control

func _on_back_pressed() -> void:
	$AudioStreamPlayer.play()
	await $AudioStreamPlayer.finished
	get_tree().change_scene_to_file("res://scenes/menu/MainMenu.tscn")
