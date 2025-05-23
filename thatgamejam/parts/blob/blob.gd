extends Node2D

var collectible_scn = preload("res://parts/collectible/physics_collectible.tscn")

var explosion_progress: float = 0.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var plant 

func _on_plant_detector_area_entered(area: Area2D) -> void:
	plant = area.owner.owner
	plant.pushing_wall.connect(_on_get_pushed)


func _on_get_pushed():
	explosion_progress += 0.1
	animation_player.play("Shake")
	if explosion_progress > 5:
		explodes()
		plant.pushing_wall.disconnect(_on_get_pushed)


func explodes():
	animation_player.play("Explodes")
	pop_collectible()
	await get_tree().create_timer(0.3).timeout
	pop_collectible()
	await get_tree().create_timer(4.0).timeout
	queue_free()


func pop_collectible():
	var new_collectible = collectible_scn.instantiate()
	Globals.props.add_child(new_collectible)
	new_collectible.global_position = self.global_position + Vector2(randf_range(-10,10),10)
