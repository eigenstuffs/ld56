class_name Job extends Area2D

@export_enum("Getting", "Prepping", "Cooking", "Plating") var job_type 
@export var time : int
@export var qte : PackedScene
@export var items_needed : Array[IngredientInfo]
@export var goblins_needed : int = 1
@export var goblins_engagaed : int = 0
@export var item_reward : IngredientInfo

signal job_done

func extra_conditions():
	pass

func give_reward():
	match job_type:
		0:
			item_reward.state = 0
			return item_reward
		1: 
			item_reward.state = 1
			return item_reward
