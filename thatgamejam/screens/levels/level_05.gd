extends BaseLevel

func _enter_tree() -> void:
	super()
	await get_tree().create_timer(1.0).timeout
	Globals.player.grow_plant.get_ressource(115)
