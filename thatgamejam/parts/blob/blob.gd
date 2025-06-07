extends Node2D

signal explodeded

var collectible_scn = preload("res://parts/collectible/physics_collectible.tscn")
var destructed_wall_scn = preload("res://parts/blob/DestructedWall.tscn")
var destructed_spike_scn = preload("res://parts/blob/DestructedSpike.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var explosion_area: Area2D = $ExplosionArea
@onready var visual: Node2D = $Visual

@export var radius = 3
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
	Globals.ongoing_explosion += 1 
	exploded = true
	animation_player.play("Explodes")
	Globals.camera.set_screenshake()
	Globals.camera.set_target(self)
	var chain_reaction = false
	await get_tree().create_timer(0.15).timeout
	destroy_tiles_around()
	explodeded.emit()
	
	for spike_area in explosion_area.get_overlapping_areas():
		var spike = spike_area.owner
		if spike.is_in_group("spike"):
			var new_destructed_spike = destructed_spike_scn.instantiate()
			new_destructed_spike.global_position = spike.global_position 
			Globals.props.add_child(new_destructed_spike)
			spike.queue_free()
		
	for blob_area in explosion_area.get_overlapping_areas():
		await get_tree().create_timer(0.1).timeout
		if is_instance_valid(blob_area):
			var blob = blob_area.owner
			if blob.is_in_group("blob"):
				if blob == self or blob.exploded:
					continue
				blob.explodes()
				chain_reaction = true
	
	for physics_collectible in get_tree().get_nodes_in_group("physics_collectible"):
		physics_collectible.apply_impulse(Vector2(0, -1))
		
	await get_tree().create_timer(2.0).timeout
	Globals.ongoing_explosion -= 1
	if Globals.ongoing_explosion == 0 :
		if Globals.plant_growing == null:
			Globals.camera.set_target(Globals.player)
		else:
			Globals.camera.set_target(Globals.plant_growing.plant_stem.end_point)
	
	await get_tree().create_timer(2.0).timeout
	queue_free()


func destroy_tiles_around():
	var tilemap = Globals.tilemap
	var center = tilemap.local_to_map(global_position)
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
