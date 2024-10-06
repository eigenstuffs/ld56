class_name Job extends Area2D

@export var time : int
@export var qte : PackedScene
@export var items_needed : Array[IngredientInfo]
@export var goblins_needed : int = 1
@export var goblins_engagaed : int = 0
@export var item_reward : Resource

signal job_done

func init():
	pass
	
func additional_conditions():
	return true
	
func give_reward():
	return null if item_reward == null else item_reward
