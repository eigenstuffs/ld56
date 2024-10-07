extends Control

class_name ScoreScreen

signal confirmed

@onready var star_texture : Texture2D = preload("res://assets/deviled_egg.png") #TODO Replace Placeholder
@onready var hbox : HBoxContainer = $CanvasLayer/TextureRect/HBoxContainer
@onready var confirm_button = $CanvasLayer/Confirm
@export var n_star : int

func init(number):
	n_star = number
	for n in range(n_star):
		var a = TextureRect.new()
		a.texture = star_texture
		hbox.add_child(a)

func _on_confirm_pressed():
	confirmed.emit()
