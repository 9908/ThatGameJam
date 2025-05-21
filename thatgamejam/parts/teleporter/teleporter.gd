extends Node2D

@export var next_level_scn: PackedScene
@export var walk_to_the_right_fade: bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == Globals.player:
		if walk_to_the_right_fade:
			Globals.player.movement.listen_to_input = false
			Globals.player.velocity.x = Globals.player.movement.MOVE_SPEED
			await get_tree().create_timer(2.0).timeout
			
		Globals.camera.set_process(false)
		Globals.level.queue_free()
		var next_level = next_level_scn.instantiate()
		Globals.main.add_child(next_level)
		Globals.player.movement.listen_to_input = true
		Globals.player.velocity.x = 0
		
		
