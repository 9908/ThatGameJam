extends CharacterBody2D

@onready var movement: Node2D = $Abilities/Movement
@onready var grow_plant: Node2D = $Abilities/GrowPlant
@onready var animation_director: Node2D = $AnimationDirector
@onready var camera_target: Marker2D = $CameraTarget/EndPoint

var active: bool = true  : set = set_active
var last_save_point: PackedVector2Array

func _ready() -> void:
	Globals.player = self


func dies(hazard):
	var respawn_pos = last_save_point.get(last_save_point.size()-1)
	Globals.player.hide()
	Globals.player.set_active(false)
	
	## FLAG-SFX "Sfx_PlayerHit"
	# Plays Once when the player is hit / dead : "Sfx_PlayerHit"
	await get_tree().create_timer(1.0).timeout
	Globals.player.set_active(true)
	Globals.player.show()
	Globals.player.global_position = respawn_pos
	
	
func set_active(new_val: bool):
	active = new_val
	movement.set_process(active)
	movement.set_physics_process(active)
	movement.set_process_input(active)
	grow_plant.set_process(active)
	grow_plant.set_physics_process(active)
	grow_plant.set_process_input(active)
	animation_director.set_process(active)
	animation_director.set_physics_process(active)
	animation_director.set_process_input(active)
	
