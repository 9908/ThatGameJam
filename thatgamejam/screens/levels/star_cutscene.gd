extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gpu_particles_2d: GPUParticles2D = $CollectibleCutscene/GPUParticles2D

var once: bool = false
func _on_star_cutscene_body_entered(body: Node2D) -> void:
	if not body == Globals.player:
		return
	if once:
		return
	once = true
	animation_player.play("StarArrives")


func shake():
	Globals.camera.set_screenshake()
