extends StaticBody2D


@onready var plant_area: Area2D = $PlantArea
@onready var asset: AnimatedSprite2D = $Asset
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func initiate(new_pos: Vector2, plant, id: int):
	global_position = new_pos
	plant_area.plant = plant
	plant_area.block_position = id
	asset.frame = 0
	asset.play("grow")

func bounce():
	animation_player.play("bounce")


func _on_plant_area_area_entered(area: Area2D) -> void:
	if area.owner == Globals.player:
		if Globals.player.velocity.y > 0:
			bounce()
