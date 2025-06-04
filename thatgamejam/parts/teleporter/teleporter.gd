extends Node2D

@export var next_level_scn: PackedScene
@export var walk_to_the_right_fade: bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == Globals.player:
		Globals.camera.set_process(false)
		if walk_to_the_right_fade:
			Globals.player.movement.listen_to_input = false
			Globals.player.velocity.x = Globals.player.movement.MOVE_SPEED
			#SoundManager.stop_music_fadeout(3.0)
			await get_tree().create_timer(1.0).timeout
			Globals.fade.fade(1.0)
			await get_tree().create_timer(1.0).timeout
			
		Globals.level.queue_free()
		var next_level = next_level_scn.instantiate()
		Globals.main.add_child(next_level)
		Globals.player.movement.listen_to_input = true
		Globals.player.velocity.x = 0
		Globals.fade.fade(0.0)
		
		
