extends Area2D

@export var one_shot: bool = false
@export var event_name: String = ""
@export var value: float = 0.0

func _on_body_entered(body: Node2D) -> void:
	if body == Globals.player:
		FmodServer.set_global_parameter_by_name(event_name, value)
		if one_shot:
			queue_free()
