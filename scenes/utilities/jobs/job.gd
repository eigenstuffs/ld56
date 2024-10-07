class_name Job extends Area2D

@export var time : int
@export var qte : PackedScene
@export var items_needed : Array
@export var goblins_needed : int = 1
@export var goblins_engagaed : int = 0
@export var item_reward : Resource

signal job_done

func pre_job(goblin : GoblinBase):
	job_done.emit()
func dur_job(goblin : GoblinBase):
	pass
func post_job(goblin : GoblinBase):
	job_done.emit()
	
func additional_conditions():
	return true
	
func give_reward():
	return null if item_reward == null else item_reward
