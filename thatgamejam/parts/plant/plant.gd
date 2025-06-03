@tool
extends Node2D

@export var init_length: float = 100.0 : set = set_init_length
signal pushing_wall

@onready var plant_stem: Node2D = $PlantStem
@onready var plant_blocks: Node2D = $PlantBlocks
@onready var plant_area: Area2D = $PlantArea

var can_grow: bool = true
var growth_rate: float = 135.0
var plant_block_scn = preload("res://parts/plant/plant_block.tscn")
var block_popped: int = 0
var block_pop_direction: int = 1
var block_vertical_spacing: float = 48.0 * 3.0
var touching_ceiling: bool = false

var plant_stem_anim_scn = preload("res://parts/plant/plant_stem_anim.tscn")
var growth_time: float = 0.0
var plant_stem_anim_popped: int = 0
var plant_stem_anims: Array
var STEM_STUCK_HEIGHT: float = 260.0
var GROWTH_TIME_INTERVAL: float = (0.5*(62.0/16.0))

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
		plant_stem.length = init_length
	set_init_length(init_length)


func set_init_length(new_length):
	init_length = new_length
	if is_instance_valid(plant_stem):
		plant_stem.length = init_length
	

func start_growing():
	if can_grow:
		set_process(true)
		if not touching_ceiling:
			for plant_anim in plant_stem_anims:
				if not plant_anim.frame == 61:
					plant_anim.play()


func stop_growing():
	set_process(false)
	for plant_anim in plant_stem_anims:
		plant_anim.pause()


func _process(delta: float) -> void:
	
	modulate.a = lerp(modulate.a, 1.0, 0.05)
	if not touching_ceiling:
		growth_time += delta
		if floori(growth_time / GROWTH_TIME_INTERVAL) >= plant_stem_anim_popped:
			pop_plant_stem_anim()
			
		plant_stem.length += delta * growth_rate
		if floori(plant_stem.length / block_vertical_spacing) > block_popped:
			pop_plant_block()
	else:
		pushing_wall.emit()


func pop_plant_stem_anim():
	var new_plant_stem_anim = plant_stem_anim_scn.instantiate()
	add_child(new_plant_stem_anim)
	new_plant_stem_anim.global_position = self.global_position + Vector2(0 , -10) + plant_stem_anim_popped*Vector2(3, -STEM_STUCK_HEIGHT)
	plant_stem_anim_popped += 1
	plant_stem_anims.append(new_plant_stem_anim)
	new_plant_stem_anim.play()
	await get_tree().create_timer(0.025).timeout
	new_plant_stem_anim.show()

func pop_plant_block(cost: int = 1):
	block_popped += 1
	block_pop_direction *= -1
	
	var new_plant_block = plant_block_scn.instantiate()
	plant_blocks.add_child(new_plant_block)
	new_plant_block.initiate(global_position + Vector2(block_pop_direction * 48 * 1.5, -plant_stem.length), self, block_popped)

	await get_tree().create_timer(0.01).timeout
	new_plant_block.show()
	if not cost == 0:
		Globals.player.grow_plant.remove_ressource(cost)
		if Globals.player.grow_plant.ressource <= 0:
			stop_growing()


func cut_off(cutoff_position: int):
	if cutoff_position == 0:
		queue_free()
	else:
		plant_stem.length = cutoff_position * block_vertical_spacing
		block_popped = cutoff_position
		for block in plant_blocks.get_children():
			if block.plant_area.block_position > cutoff_position:
				block.queue_free()
				
		var plant_stem_height: float = 0
		var id: int = 0
		var junction_stem = null
		var junction_stem_id: int = 0
		for plant_stem_anim in plant_stem_anims:
			#print(str(plant_stem_height) + "   ---  " + str(plant_stem.length))
			if plant_stem_height < plant_stem.length:
				#Keep Block
				junction_stem = plant_stem_anim
				junction_stem_id = id
			else:
				# erase block
				if id == plant_stem_anims.size() - 1:
					var junction_stem_frame = (fmod(plant_stem.length, STEM_STUCK_HEIGHT) / STEM_STUCK_HEIGHT) * 31
					junction_stem.frame = junction_stem_frame  
					if not junction_stem_id == 0:
						plant_stem_anims[junction_stem_id-1].frame = 31 + junction_stem_frame
					growth_time = (plant_stem_anim_popped-2)*GROWTH_TIME_INTERVAL + 1 # - junction_stem_frame/62 * GROWTH_TIME_INTERVAL
				plant_stem_anim.queue_free()
				plant_stem_anim_popped -= 1
			plant_stem_height += STEM_STUCK_HEIGHT
			id += 1
		
		await get_tree().create_timer(0.1).timeout
		plant_stem_anims = clean_array(plant_stem_anims)
		print(plant_stem_anims)

func _on_plant_stem_plant_collided() -> void:
	touching_ceiling = true
	for plant_anim in plant_stem_anims:
		plant_anim.pause()


func clean_array(dirty_array: Array) -> Array:
	var cleaned_array = []
	for item in dirty_array:
		if is_instance_valid(item) and not item == null:
			cleaned_array.push_back(item)
	return cleaned_array
