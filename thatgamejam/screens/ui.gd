extends CanvasLayer

@onready var fps: RichTextLabel = $FPS

func _process(_delta: float) -> void:
	fps.text = str(Engine.get_frames_per_second())
