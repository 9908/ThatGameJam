extends CharacterBody2D

@onready var movement: Node2D = $Abilities/Movement
@onready var grow_plant: Node2D = $Abilities/GrowPlant
@onready var animation_director: Node2D = $AnimationDirector
@onready var camera_target: Marker2D = $CameraTarget/EndPoint
@onready var visual: Node2D = $Visual
@onready var ressource_visualisation: Node2D = $Visual/Backpack/RessourceVisualisation

var dead_particle_scn = preload("res://parts/plant/dead_particle.tscn")

var active: bool = true  : set = set_active
var last_save_point: PackedVector2Array
var tween: Tween

var fall_distance: float = 0
@onready var debug: RichTextLabel = $Debug

func _ready() -> void:
	Globals.player = self


func _process(delta: float) -> void:
	if velocity.y > 0:
		fall_distance += delta
	elif velocity.y < 0:
		fall_distance = 0
	debug.text = str(fall_distance)
	
	
func dies(hazard):
	var respawn_pos = last_save_point.get(last_save_point.size()-1)
	if tween:
		tween.kill()
	modulate.a = 0
	Globals.player.set_active(false)
	var dead_particle = dead_particle_scn.instantiate()
	dead_particle.global_position = self.global_position
	Globals.props.add_child(dead_particle)
	
	## FLAG-SFX "Sfx_PlayerHit"
	# Plays Once when the player is hit / dead : "Sfx_PlayerHit"
	FmodServer.play_one_shot("event:/hurt")
	await get_tree().create_timer(1.0).timeout
	if active:
		return
	velocity = Vector2.ZERO
	Globals.player.set_active(true)
	Globals.player.global_position = respawn_pos
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate:a", 1.0, 2.5)
	
	
func set_active(new_val: bool):
	active = new_val
	movement.set_process(active)
	movement.set_physics_process(active)
	movement.set_process_input(active)
	grow_plant.set_process(active)
	grow_plant.set_physics_process(active)
	grow_plant.set_process_input(active)
	#animation_director.set_process(active)
	#animation_director.set_physics_process(active)
	#animation_director.set_process_input(active)
