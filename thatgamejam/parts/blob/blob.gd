extends Node2D

var collectible_scn = preload("res://parts/collectible/physics_collectible.tscn")
var destructed_wall_scn = preload("res://parts/blob/DestructedWall.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var explosion_area: Area2D = $ExplosionArea

var explosion_progress: float = 0.0
var plant 
var exploded: bool = false

func _on_plant_detector_area_entered(area: Area2D) -> void:
	plant = area.owner.owner
	plant.pushing_wall.connect(_on_get_pushed)


func _on_get_pushed():
	explosion_progress += 0.1
	animation_player.play("Shake")
	if explosion_progress > 1:
		explodes()
		plant.pushing_wall.disconnect(_on_get_pushed)
		plant.touched_explosive_blob()


func explodes():
	if exploded:
		return
	Globals.ongoing_explosion = true
	exploded = true
	animation_player.play("Explodes")
	Globals.camera.set_target(self)
	var chain_reaction = false
	await get_tree().create_timer(0.15).timeout
	destroy_tiles_around()
	for blob_area in explosion_area.get_overlapping_areas():
		await get_tree().create_timer(0.2).timeout
		var blob = blob_area.owner
		if blob == self or blob.exploded:
			continue
		blob.explodes()
		chain_reaction = true
		
	if not chain_reaction:
		await get_tree().create_timer(1.0).timeout
		if Globals.plant_growing == null:
			Globals.camera.set_target(Globals.player)
		else:
			Globals.camera.set_target(Globals.plant_growing.plant_stem.end_point)
		Globals.ongoing_explosion = false
		
	await get_tree().create_timer(4.0).timeout
	queue_free()


func destroy_tiles_around():
	var tilemap = Globals.tilemap
	var center = tilemap.local_to_map(global_position)
	var radius = 3
	var radius_squared = radius * radius

	for x in range(-ceil(radius), ceil(radius) + 1):
		for y in range(-ceil(radius), ceil(radius) + 1):
			var offset = Vector2i(x, y)
			if offset.length_squared() <= radius_squared:
				var tile_pos = center + offset
				if tilemap.get_cell_source_id(tile_pos) != -1:
					tilemap.set_cell(tile_pos, -1) 
					var new_destructed_wall = destructed_wall_scn.instantiate()
					new_destructed_wall.global_position = self.global_position + Vector2(x,y) * 48
					Globals.props.add_child(new_destructed_wall)
			
			
func pop_collectible():
	var new_collectible = collectible_scn.instantiate()
	Globals.props.add_child(new_collectible)
	new_collectible.global_position = self.global_position + Vector2(randf_range(-10,10),10)
