extends Node2D

var completed: bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	await get_tree().create_timer(randf_range(1.0, 5.0)).timeout
	animation_player.play("new_animation")


func fade_away():
	await get_tree().create_timer(3.0).timeout
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate:a", 0, 1.5)
