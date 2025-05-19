extends Node2D

var plant_scn = preload("res://parts/plant/plant.tscn")
var current_growing_plant = null

func _physics_process(_delta):
	if Input.is_action_just_pressed("grow"):
		start_growing()
	elif Input.is_action_just_released("grow"):
		stop_growing()


func start_growing():
	if not owner.is_on_floor():
		return
	owner.movement.set_physics_process(false)
	current_growing_plant = plant_scn.instantiate()
	Globals.plants.add_child(current_growing_plant)
	current_growing_plant.global_position = owner.global_position + Vector2(0, 1)
	current_growing_plant.start_growing()


func stop_growing():
	if current_growing_plant == null:
		return
	owner.movement.set_physics_process(true)
	current_growing_plant.stop_growing()
	current_growing_plant = null
