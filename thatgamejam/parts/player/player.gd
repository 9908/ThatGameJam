extends CharacterBody2D

@onready var movement: Node2D = $Abilities/Movement
@onready var grow_plant: Node2D = $Abilities/GrowPlant
@onready var animation_director: Node2D = $AnimationDirector

var active: bool = true  : set = set_active

func _ready() -> void:
	Globals.player = self
	
	
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
	
