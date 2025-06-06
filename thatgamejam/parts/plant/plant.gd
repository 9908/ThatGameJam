@tool
extends Node2D

@export var init_length: float = 100.0 : set = set_init_length
signal pushing_wall

@onready var plant_stem: Node2D = $PlantStem
@onready var plant_blocks: Node2D = $PlantBlocks
@onready var plant_area: Area2D = $PlantArea

var cut_particle_scn = preload("res://parts/plant/cut_particle.tscn")

var can_grow: bool = true
var growth_rate: float = 135.0
var plant_block_scn = preload("res://parts/plant/plant_block.tscn")
var block_popped: int = 0
var block_pop_direction: int = 1
var block_vertical_spacing: float = 48.0 * 3.0
var touching_ceiling: bool = false

var plant_stem_anim_scn = preload("res://parts/plant/plant_stem_anim.tscn")
#var growth_time: float = 0.0
var plant_stem_anim_popped: int = 0
var plant_stem_anims: Array
var STEM_STUCK_HEIGHT: float = 260.0
var GROWTH_TIME_INTERVAL: float = (0.5*(62.0/16.0))
var can_touch_ceiling: bool = false

var plant_side_stem_anim_scn = preload("res://parts/plant/plant_side_stem_anim.tscn")
var plant_side_stem_anims: Array

@onready var line_2d: Line2D = $Line2D
@onready var debug: RichTextLabel = $Debug


func _ready() -> void:
	set_process(false)
	plant_area.plant = self
	plant_stem.length = 0
	if init_length == 0:
		modulate.a = 0
	else:
		for i in range(0, floori(init_length / block_vertical_spacing)):
			plant_stem.length += block_vertical_spacing
			pop_plant_block(0)
		
		#growth_time = get_growth_time_from_length(init_length)
		var plant_stem_anim_stucks = floori(get_growth_time_from_length(init_length) / GROWTH_TIME_INTERVAL)
		var junction_stem_frame_last = (fmod(init_length, STEM_STUCK_HEIGHT) / STEM_STUCK_HEIGHT) * 31
		var junction_stem_frame_prelast = 31 + junction_stem_frame_last
		for i in range(0, plant_stem_anim_stucks + 1):
			if i == plant_stem_anim_stucks:
				pop_plant_stem_anim(false, junction_stem_frame_last)
			elif i == plant_stem_anim_stucks - 1:
				pop_plant_stem_anim(false, junction_stem_frame_prelast)
			else:
				pop_plant_stem_anim(false)
	set_init_length(init_length)

	await get_tree().create_timer(.2).timeout
	can_touch_ceiling = true
	#for i in range(0, 10000):
		#var new_side_stem_pos_y = -i + 35
		#var sin_point = 15*sin(2*PI*(new_side_stem_pos_y+85)/(STEM_STUCK_HEIGHT)) - 3 * (new_side_stem_pos_y+85)/STEM_STUCK_HEIGHT
		#line_2d.add_point(Vector2(sin_point, new_side_stem_pos_y + 85))
		
		
func get_growth_time_from_length(length_loc) -> float:
	var growth_time_loc = GROWTH_TIME_INTERVAL * (length_loc / STEM_STUCK_HEIGHT)
	return growth_time_loc
	

func set_init_length(new_length):
	init_length = new_length
	if is_instance_valid(plant_stem):
		plant_stem.length = init_length
	

func start_growing():
	# FLAG_SFX
	if can_grow:
		set_process(true)
		if not touching_ceiling:
			for plant_anim in plant_stem_anims:
				if is_instance_valid(plant_anim):
					if not plant_anim.frame == 61:
						plant_anim.play_until_frame()


func stop_growing():
	set_process(false)
	for plant_anim in plant_stem_anims:
		if is_instance_valid(plant_anim):
			plant_anim.stop_anim()
	if block_popped == 0:
		kill_plant()


func _process(delta: float) -> void:
	#debug.text = str(growth_time)
	modulate.a = lerp(modulate.a, 1.0, 0.05)
	if not touching_ceiling:
		#growth_time += delta
		plant_stem.length += delta * growth_rate
		if floori(plant_stem.length / STEM_STUCK_HEIGHT) >= plant_stem_anim_popped:
		#if floori(growth_time / GROWTH_TIME_INTERVAL) >= plant_stem_anim_popped:
			pop_plant_stem_anim()
			
		if floori(plant_stem.length / block_vertical_spacing) > block_popped:
			pop_plant_block()
	else:
		pushing_wall.emit()


func pop_plant_stem_anim(make_sound: bool = true, last_frame: int = 61):
	var new_plant_stem_anim = plant_stem_anim_scn.instantiate()
	add_child(new_plant_stem_anim)
	new_plant_stem_anim.frame = 0
	new_plant_stem_anim.global_position = self.global_position + Vector2(0 , -10) + plant_stem_anim_popped*Vector2(3, -STEM_STUCK_HEIGHT)
	plant_stem_anim_popped += 1
	plant_stem_anims.append(new_plant_stem_anim)
	new_plant_stem_anim.play_until_frame(last_frame)
	await get_tree().create_timer(0.025).timeout
	new_plant_stem_anim.show()


func pop_plant_block(cost: int = 1):
	block_popped += 1
	block_pop_direction *= -1
	var stem_length_loc = -plant_stem.length
	var block_popped_loc = block_popped
	var block_pop_direction_loc = block_pop_direction
	var new_side_stem = plant_side_stem_anim_scn.instantiate()
	plant_side_stem_anims.append(new_side_stem)
	add_child(new_side_stem)
	var plant_block_pos_x = block_pop_direction_loc * 48 * 1.5 
	var new_side_stem_pos_y = stem_length_loc + 35
	plant_block_pos_x += - 3 * (new_side_stem_pos_y+85)/STEM_STUCK_HEIGHT
	var sin_point = 15*sin(2*PI*(new_side_stem_pos_y+85)/(STEM_STUCK_HEIGHT)) - 3 * (new_side_stem_pos_y+85)/STEM_STUCK_HEIGHT
	var distance_to_stem = sin_point - plant_block_pos_x

	new_side_stem.global_position = global_position + Vector2(plant_block_pos_x, new_side_stem_pos_y)
	new_side_stem.scale.x *= -block_pop_direction_loc
	new_side_stem.scale.x *= abs(distance_to_stem/79.0)
	
	await get_tree().create_timer(0.8).timeout
	var new_plant_block = plant_block_scn.instantiate()
	plant_blocks.add_child(new_plant_block)
	new_plant_block.initiate(global_position + Vector2(plant_block_pos_x, stem_length_loc), self, block_popped_loc)
	
	await get_tree().create_timer(0.01).timeout
	new_plant_block.show()
	
	if not cost == 0:
		Globals.player.grow_plant.remove_ressource(cost)
		if Globals.player.grow_plant.ressource <= 0:
			stop_growing()

		## FLAG-SFX "Sfx_Flower"
		FmodServer.play_one_shot("event:/flower")
		# Plays Once when a flower platform grows : "Sfx_Flower"


func kill_plant():
	## FLAG-SFX "Sfx_StemStop"
	# Plays Once when the Plant is destroyed : "Sfx_StemStop"
	var particle_cut = cut_particle_scn.instantiate()
	particle_cut.global_position = self.global_position
	Globals.props.add_child(particle_cut)
	queue_free()
		
		
func cut_off(cutoff_position: int):
	if cutoff_position == 0:
		kill_plant()
		FmodServer.play_one_shot("event:/popout")
	else:
		var block_destroyed: bool = false
		plant_stem.length = cutoff_position * block_vertical_spacing + 75
		block_popped = cutoff_position
		for block in plant_blocks.get_children():
			if block.plant_area.block_position > cutoff_position:
				block.queue_free()
				block_destroyed = true
				touching_ceiling = false
		if fmod(cutoff_position, 2) == 0:
			block_pop_direction = 1
		else:
			block_pop_direction = -1
		
		if block_destroyed:
			pass
			## FLAG-SFX "Sfx_PlantCut"
			FmodServer.play_one_shot("event:/popout")
			# Plays Once when the Plant is cutoff intermediary level : "Sfx_PlantCut"
		
		var plant_stem_height: float = 0
		var id: int = 0
		var junction_stem = null
		var junction_stem_id: int = 0
		for plant_stem_anim in plant_stem_anims:
			if plant_stem_height < plant_stem.length:
				#Keep Block
				junction_stem = plant_stem_anim
				junction_stem_id = id
			else:
				# erase block
				plant_stem_anim.queue_free()
				plant_stem_anim_popped -= 1
			id += 1
			plant_stem_height += STEM_STUCK_HEIGHT
			
		for plant_stem_side_anim in plant_side_stem_anims:
			if plant_stem_side_anim.global_position.y  < global_position.y - plant_stem.length:
				plant_stem_side_anim.queue_free()
			
		var junction_stem_frame = (fmod(plant_stem.length, STEM_STUCK_HEIGHT) / STEM_STUCK_HEIGHT) * 31
		junction_stem.frame = junction_stem_frame  
		if not junction_stem_id == 0:
			plant_stem_anims[junction_stem_id-1].frame = 31 + junction_stem_frame
		#growth_time = get_growth_time_from_length(plant_stem.length) 

		await get_tree().create_timer(0.01).timeout
		var particle_cut = cut_particle_scn.instantiate()
		particle_cut.global_position = plant_stem.end_point.global_position
		Globals.props.add_child(particle_cut)
		
		await get_tree().create_timer(0.1).timeout
		plant_stem_anims = clean_array(plant_stem_anims)
		plant_side_stem_anims = clean_array(plant_side_stem_anims)


func _on_plant_stem_plant_collided() -> void:
	if not can_touch_ceiling:
		return
	
	touching_ceiling = true
	for plant_anim in plant_stem_anims:
		plant_anim.stop_anim()


func touched_explosive_blob():
	touching_ceiling = false
	for plant_anim in plant_stem_anims:
		plant_anim.play_until_frame()
		

func clean_array(dirty_array: Array) -> Array:
	var cleaned_array = []
	for item in dirty_array:
		if is_instance_valid(item) and not item == null:
			cleaned_array.push_back(item)
	return cleaned_array


func _on_wiggle_area_area_entered(area: Area2D) -> void:
	if area.owner == Globals.player and block_popped == 0:
		wiggle()
		# SFX - Regi wiggle plant
		FmodServer.play_one_shot("event:/bulb")


func wiggle():
	for plant_anim in plant_stem_anims:
		plant_anim.wiggle()
