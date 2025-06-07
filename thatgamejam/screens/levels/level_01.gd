extends BaseLevel

func _enter_tree() -> void:
	Globals.fade.modulate.a = 1.0
	Globals.fade.target_alpha = 1.0
	super()
	await get_tree().create_timer(1.5).timeout
	Globals.fade.fade(0.0, 0.005)
