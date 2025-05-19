extends CharacterBody2D

@onready var movement: Node2D = $Abilities/Movement
@onready var grow_plant: Node2D = $Abilities/GrowPlant
@onready var animation_director: Node2D = $AnimationDirector

func _ready() -> void:
	Globals.player = self
