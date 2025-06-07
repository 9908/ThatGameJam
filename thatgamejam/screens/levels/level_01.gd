extends BaseLevel

func _enter_tree() -> void:
	Globals.fade.modulate.a = 1.0
	Globals.fade.target_alpha = 1.0
	super()
	await get_tree().create_timer(1.5).timeout
	Globals.fade.fade(0.0, 0.005)
	await get_tree().create_timer(1.5).timeout
	Globals.player.movement.jumped.connect(_on_jumped)
	Globals.tutorial.show_text("Keyboard arrows to move and jump")
	
func _on_jumped():
	Globals.player.movement.jumped.disconnect(_on_jumped)
	Globals.tutorial.learned()


func _on_collectible_cutscene_collectid() -> void:
	Globals.player.grow_plant.learned_to_grow.connect(_on_learned_to_grow)
	Globals.tutorial.show_text("Shift to grow a plant")


func _on_learned_to_grow():
	Globals.player.grow_plant.learned_to_grow.disconnect(_on_learned_to_grow)
	Globals.tutorial.learned()
