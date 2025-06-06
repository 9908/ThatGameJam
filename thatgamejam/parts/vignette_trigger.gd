extends Area2D

@export var one_shot: bool = false
@export var color: Color = Color.BLACK
@export var transition_time: float = 3.0
@export var cut_off: float = 0.709
@export var smooth_size: float = 0.247

func _on_body_entered(body: Node2D) -> void:
	if body == Globals.player:
		Globals.vignette.set_vignette(color, transition_time, cut_off, smooth_size)
		if one_shot:
			queue_free()
