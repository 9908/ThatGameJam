@tool
extends Node2D

@export var length: float = 100.0
@onready var line_2d: Line2D = $Line2D
@onready var end_point: Marker2D = $EndPoint

func _process(_delta: float) -> void:
	line_2d.points[1].y = -length
	end_point.position = line_2d.points[1]
