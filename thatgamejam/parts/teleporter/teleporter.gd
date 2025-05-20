extends Node2D

@export var next_level_scn: PackedScene

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == Globals.player:
		Globals.camera.set_process(false)
		Globals.level.queue_free()
		var next_level = next_level_scn.instantiate()
		Globals.main.add_child(next_level)
		
		
