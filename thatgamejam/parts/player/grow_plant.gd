extends Node2D

var ressource: int = 0

var plant_scn = preload("res://parts/plant/plant.tscn")
var nearby_plant = null
var nearby_plant_count: int = 0
var plant_block_id: int = 0
var growing: bool = false
@onready var plant_detector: Area2D = $"../../Areas/PlantDetector"


func _physics_process(_delta):
	if Input.is_action_pressed("grow"):
		start_growing()
	elif Input.is_action_just_released("grow"):
		stop_growing()
	elif Input.is_action_just_pressed("cut"):
		cut_plant()
		

func start_growing():
	if growing or not owner.is_on_floor() or ressource <= 0: 
		return
	growing = true
	owner.movement.set_physics_process(false)
	if nearby_plant == null:
		nearby_plant = plant_scn.instantiate()
		nearby_plant.init_length = 0.0
		Globals.plants.add_child(nearby_plant)
		nearby_plant.global_position = owner.global_position + Vector2(0, 1)
		nearby_plant.start_growing()
		SoundManager.play("flower_open")
	else:
		nearby_plant.start_growing()
		SoundManager.play("flower_open")
	Globals.camera.set_target(nearby_plant.plant_stem.end_point)
	

func stop_growing():
	if nearby_plant == null or not growing:
		return
	growing = false
	owner.movement.set_physics_process(true)
	nearby_plant.stop_growing()
	Globals.camera.set_target(Globals.player.camera_target)


func cut_plant():
	for plant_area in plant_detector.get_overlapping_areas():
		if plant_area.plant.block_popped > 0:
			nearby_plant = plant_area.plant
	if nearby_plant == null:
		return
	if plant_block_id >= nearby_plant.block_popped:
		return
	get_ressource(nearby_plant.block_popped - plant_block_id)
	nearby_plant.cut_off(plant_block_id)
	

func _on_plant_detector_area_entered(area: Area2D) -> void:
	nearby_plant_count += 1
	nearby_plant = area.plant
	plant_block_id = area.block_position
	

func _on_plant_detector_area_exited(_area: Area2D) -> void:
	nearby_plant_count -= 1
	if nearby_plant_count <= 0:
		nearby_plant = null


func _on_collectible_detector_area_entered(area: Area2D) -> void:
	area.owner.collected()
	get_ressource(6)


func get_ressource(amount: int = 6):
	ressource += amount
	owner.animation_director.backpack.set_value(ressource)
	Globals.ressource = ressource
	

func remove_ressource(amount: int = 1):
	ressource -= amount
	owner.animation_director.backpack.set_value(ressource)
	Globals.ressource = ressource
