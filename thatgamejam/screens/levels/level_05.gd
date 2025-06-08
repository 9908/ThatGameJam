extends BaseLevel

@onready var missing_stars: Node2D = $FinalSunset/MissingStars
@onready var final_camera: Marker2D = $FinalSunset/FinalCamera
@onready var fellow_player: AnimatedSprite2D = $Agents/FellowPlayer
@onready var animation_player: AnimationPlayer = $FinalSunset/AnimationPlayer
@onready var completed_stars: Node2D = $FinalSunset/CompletedStars

var completed_star = preload("res://parts/completed_star.tscn")
var secret_ending: bool = false

func _enter_tree() -> void:
	super()
	await get_tree().create_timer(1.0).timeout
	Globals.player.grow_plant.get_ressource(115)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == Globals.player:
		Globals.camera.set_new_zoom(Vector2(0.7,0.7))
		Globals.camera.set_target(final_camera)
		Globals.player.set_active(false)
		Globals.player.velocity = Vector2.ZERO
		if Globals.player.global_position.x > final_camera.global_position.x:
			fellow_player.global_position = Globals.player.global_position - Vector2(150,0)
		else:
			fellow_player.global_position = Globals.player.global_position + Vector2(150,0)
		fellow_player.scale.x = 0.5 * -Globals.player.visual.scale.x
		await get_tree().create_timer(2.0).timeout
		var spawn_wait = 1.0
		secret_ending = true
		for missing_star in missing_stars.get_children():
			if missing_star.completed:
				continue
			if Globals.player.grow_plant.ressource <= 0:
				secret_ending = false
				continue
			missing_star.completed = true
			missing_star.fade_away()
			var new_star = completed_star.instantiate()
			new_star.global_position = Globals.player.ressource_visualisation.global_position
			new_star.move_to(missing_star.global_position)
			Globals.props.add_child(new_star)
			Globals.player.grow_plant.remove_ressource(1)
			
			# FLAG-SFX - REGi-SFX - stars
			FmodServer.play_one_shot("event:/rhode")
			
			await get_tree().create_timer(spawn_wait).timeout
			spawn_wait -= 0.1
			if spawn_wait <= 0.1:
				spawn_wait = 0.1
		
		if secret_ending:
			FmodServer.set_global_parameter_by_name("area", 6.0)
			animation_player.play("SecretEnding")
			var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
			tween.tween_property(Globals.props, "modulate:a", 0.0, 7.5)
		else:
			Globals.camera.set_new_zoom(Vector2(1.0,1.0))
			Globals.camera.set_target(Globals.player)
			Globals.player.set_active(true)
		
	
