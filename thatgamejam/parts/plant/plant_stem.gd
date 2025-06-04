@tool
extends Node2D

signal plant_collided

@export var length: float = 100.0
@onready var line_2d: Line2D = $Line2D
@onready var end_point: Marker2D = $EndPoint


func _ready() -> void:
	if not Engine.is_editor_hint():
		$Line2D.hide()
		$EndPoint/ColorRect.hide()
	
	
func _process(_delta: float) -> void:
	line_2d.points[1].y = -length
	end_point.position = line_2d.points[1]


func _on_collision_detector_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if length > 50.0:
		plant_collided.emit()
