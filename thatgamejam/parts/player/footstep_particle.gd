extends Node2D

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

func _ready() -> void:
	gpu_particles_2d.emitting = true
	await get_tree().create_timer(4.0).timeout
	queue_free()
