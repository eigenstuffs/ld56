class_name Job extends Area2D

@export var time : int
@export var qte : PackedScene
@export var items_needed : Array
@export var goblins_needed : int = 1
@export var goblins_engagaed : int = 0

signal job_done
