extends Control

class_name ScoreScreen

signal confirmed
signal replay

@onready var star_texture : Texture2D = preload("res://assets/deviled_egg.png") #TODO Replace Placeholder
@onready var one_star : Texture2D = preload("res://assets/score_screen/1star.png")
@onready var two_star : Texture2D = preload("res://assets/score_screen/2star.png")
@onready var three_star : Texture2D = preload("res://assets/score_screen/3star.png")

@onready var hbox : HBoxContainer = $CanvasLayer/TextureRect/HBoxContainer
@onready var confirm_button = $CanvasLayer/Confirm
@export var n_star : int
@onready var textures : Array = [one_star, two_star, three_star]

func init(number):
	n_star = number
	for n in range(n_star):
		$CanvasLayer/TextureRect.texture = textures[n]
		$AudioStreamPlayer.pitch_scale += n*0.25
		$AudioStreamPlayer.play()
		await $AudioStreamPlayer.finished
		#await get_tree().create_timer(0.8).timeout

func _on_confirm_pressed():
	confirmed.emit()

func _on_replay_pressed():
	replay.emit()
