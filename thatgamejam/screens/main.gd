extends Node2D

func _ready() -> void:
	Globals.main = self
	$FmodMusic.play()
