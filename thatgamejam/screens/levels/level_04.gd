extends BaseLevel

var color: Color = Color.BLACK
var transition_time: float = 3.0
var cut_off: float = 1.0
var smooth_size: float = 0.247

func _on_big_blob_explodeded() -> void:
	Globals.vignette.set_vignette(color, transition_time, cut_off, smooth_size)
