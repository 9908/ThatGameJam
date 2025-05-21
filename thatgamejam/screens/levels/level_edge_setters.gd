extends Node2D

@onready var left: Marker2D = $Left
@onready var right: Marker2D = $Right
@onready var top: Marker2D = $Top
@onready var bottom: Marker2D = $Bottom

func _ready() -> void:
	Globals.camera.set_boundaries(left, right, top, bottom)
