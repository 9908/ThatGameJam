extends StaticBody2D


@onready var plant_area: Area2D = $PlantArea

func initiate(new_pos: Vector2, plant):
	global_position = new_pos
	plant_area.plant = plant
