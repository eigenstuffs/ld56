class_name NewGoblin extends Area2D

@export var points : Node2D

@export var fridge_area : Area2D
@export var bird_area : Area2D
@export var prep_area : Area2D
@export var plate_area : Area2D
@export var cook_area : Area2D
@export var standby_area : Area2D

@onready var areas = [fridge_area, bird_area, prep_area, plate_area, cook_area, standby_area]

var starting_area : Area2D = null
var target_area : Area2D = null

signal done_moving

func _input(event):
	if event.is_action_pressed("LMB"):
		var starting_pos = global_position
		
func get_current_point():
	var closest = null
	var closest_dist = 99999
	for i in areas:
		var dist = global_position.distance_to(i.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest = i.name
	return closest

func go():
	if target_area != null and starting_area != null:
		$CollisionShape2D.disabled = true
		var path : Array = []
		if target_area.global_position.y > starting_area.global_position.y: # target is lower
			for i in points.get_children():
				if i is not Area2D:
					if i.global_position.y >= starting_area.global_position.y:
						if i.global_position.y <= target_area.global_position.y:
							path.append(i)
							path.sort_custom(sort_descending)
		else: # target is higher
			for i in points.get_children():
				if i is not Area2D:
					if i.global_position.y <= starting_area.global_position.y:
						if i.global_position.y >= target_area.global_position.y:
							path.append(i)
							path.sort_custom(sort_ascending)
		path.append(target_area)
		for i in path:
			move_to_point(global_position, i.global_position)
			await done_moving
		var a = create_tween()
		a.tween_property(self, "global_position",
		self.global_position + Vector2(randi_range(-25, 25), randi_range(-3, 3)), 0.2)
		await a.finished
		target_area = null
		starting_area = null
		$CollisionShape2D.disabled = false

func sort_ascending(a, b):
	if a.global_position.y > b.global_position.y:
		return true
	return false
		
func sort_descending(a, b):
	if a.global_position.y < b.global_position.y:
		return true
	return false
	
func move_to_point(point_a : Vector2, point_b : Vector2):
	var a = create_tween()
	var distance = point_a.distance_to(point_b)
	var time = distance * 0.005
	
	a.tween_property(
		self,
		"global_position",
		point_b,
		time
	)
	
	await a.finished
	done_moving.emit()
	

func _on_fridge_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("LMB"):
		if starting_area != null:
			if target_area == null:
				target_area = fridge_area
				go()
				
func _on_bird_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("LMB"):
		if starting_area != null:
			if target_area == null:
				target_area = bird_area
				go()

func _on_prep_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("LMB"):
		if starting_area != null:
			if target_area == null:
				target_area = prep_area
				go()

func _on_plate_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("LMB"):
		if starting_area != null:
			if target_area == null:
				target_area = plate_area
				go()

func _on_cook_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("LMB"):
		if starting_area != null:
			if target_area == null:
				target_area = cook_area
				go()

func _on_standby_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("LMB"):
		if starting_area != null:
			if target_area == null:
				target_area = standby_area
				go()

func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("LMB"):
		set_deferred("starting_area", self)
