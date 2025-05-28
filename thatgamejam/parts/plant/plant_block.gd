extends StaticBody2D


@onready var plant_area: Area2D = $PlantArea
@onready var asset: AnimatedSprite2D = $Asset

func initiate(new_pos: Vector2, plant, id: int):
	global_position = new_pos
	plant_area.plant = plant
	plant_area.block_position = id
	asset.frame = 0
	asset.play("grow")
