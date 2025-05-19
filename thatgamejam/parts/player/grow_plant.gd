extends Node2D

var plant_scn = preload("res://parts/plant/plant.tscn")
var nearby_plant = null
var nearby_plant_count: int = 0
var growing: bool = false

func _physics_process(_delta):
	if Input.is_action_pressed("grow"):
		start_growing()
	elif Input.is_action_just_released("grow"):
		stop_growing()
		

func start_growing():
	if growing or not owner.is_on_floor(): 
		return
	growing = true
	owner.movement.set_physics_process(false)
	if nearby_plant == null:
		nearby_plant = plant_scn.instantiate()
		Globals.plants.add_child(nearby_plant)
		nearby_plant.global_position = owner.global_position + Vector2(0, 1)
		nearby_plant.start_growing()
	else:
		nearby_plant.start_growing()
	Globals.camera.set_target(nearby_plant.plant_stem.end_point)
	

func stop_growing():
	if nearby_plant == null or not growing:
		return
	growing = false
	owner.movement.set_physics_process(true)
	nearby_plant.stop_growing()
	Globals.camera.set_target(Globals.player)


func _on_plant_detector_area_entered(area: Area2D) -> void:
	nearby_plant_count += 1
	nearby_plant = area.plant


func _on_plant_detector_area_exited(_area: Area2D) -> void:
	nearby_plant_count -= 1
	if nearby_plant_count <= 0:
		nearby_plant = null
