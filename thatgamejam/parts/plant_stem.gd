@tool
extends Node2D

@export var length: float = 100.0
@onready var line_2d: Line2D = $Line2D

func _process(_delta: float) -> void:
	line_2d.points[1].y = -length
