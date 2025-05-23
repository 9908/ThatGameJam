@tool
extends Node2D

@export var init_length: float = 100.0 : set = set_init_length
signal pushing_wall

@onready var plant_stem: Node2D = $PlantStem
@onready var plant_blocks: Node2D = $PlantBlocks
@onready var plant_area: Area2D = $PlantArea

var can_grow: bool = true
var growth_rate: float = 150.0
var plant_block_scn = preload("res://parts/plant/plant_block.tscn")
var block_popped: int = 0
var block_pop_direction: int = 1
var block_vertical_spacing: float = 48.0 * 3.0
var touching_ceiling: bool = false

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


func stop_growing():
	set_process(false)


func _process(delta: float) -> void:
	modulate.a = lerp(modulate.a, 1.0, 0.05)
	if not touching_ceiling:
		plant_stem.length += delta * growth_rate
		if floori(plant_stem.length / block_vertical_spacing) > block_popped:
			pop_plant_block()
	else:
		pushing_wall.emit()
		

func pop_plant_block(cost: int = 1):
	block_popped += 1
	block_pop_direction *= -1
	
	var new_plant_block = plant_block_scn.instantiate()
	plant_blocks.add_child(new_plant_block)
	new_plant_block.initiate(global_position + Vector2(block_pop_direction * 48 * 1.5, -plant_stem.length), self, block_popped)

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


func _on_plant_stem_plant_collided() -> void:
	#can_grow = false
	touching_ceiling = true
	#stop_growing()
