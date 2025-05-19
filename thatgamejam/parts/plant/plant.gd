extends Node2D

@onready var plant_stem: Node2D = $PlantStem
@onready var plant_blocks: Node2D = $PlantBlocks
@onready var plant_area: Area2D = $PlantArea

var growth_rate: float = 150.0
var plant_block_scn = preload("res://parts/plant/plant_block.tscn")
var block_popped: int = 0
var block_pop_direction: int = 1
var block_vertical_spacing: float = 48.0 * 3.0

@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var rich_text_label_2: RichTextLabel = $RichTextLabel2


func _ready() -> void:
	set_process(false)
	plant_area.plant = self
	plant_stem.length = 0
	modulate.a = 0


func start_growing():
	set_process(true)


func stop_growing():
	set_process(false)


func _process(delta: float) -> void:
	modulate.a = lerp(modulate.a, 1.0, 0.05)
	plant_stem.length += delta * growth_rate
	if floori(plant_stem.length / block_vertical_spacing) > block_popped:
		pop_plant_block()
		

func pop_plant_block():
	block_popped += 1
	block_pop_direction *= -1
	
	var new_plant_block = plant_block_scn.instantiate()
	plant_blocks.add_child(new_plant_block)
	new_plant_block.initiate(global_position + Vector2(block_pop_direction * 48 * 1.5, -plant_stem.length), self, block_popped)

	Globals.player.grow_plant.remove_ressource(1)
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
