extends Node2D

func _draw() -> void:
	draw_arc(Vector2.ZERO, 50.0, 0.0, PI/2, 40, Color.WHITE, width: float = -1.0, true)
