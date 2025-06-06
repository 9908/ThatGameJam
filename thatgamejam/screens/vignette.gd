extends ColorRect


var _tween: Tween 


func _ready():
	Globals.vignette = self
	
	
func set_vignette(color: Color, transition_time: float = 3.0, cut_off: float = 0.709, smooth_size: float = 0.247):
	if _tween:
		_tween.kill()

	_tween = create_tween()


	var shader_mat = material
	if shader_mat is ShaderMaterial:
		var current_cutoff = shader_mat.get_shader_parameter("cutoff")
		_tween.tween_method(
			func(value): shader_mat.set_shader_parameter("cutoff", value),
			current_cutoff,
			cut_off,
			transition_time
		)

		var current_smooth = shader_mat.get_shader_parameter("smooth_size")
		_tween.tween_method(
			func(value): shader_mat.set_shader_parameter("smooth_size", value),
			current_smooth,
			smooth_size,
			transition_time
		)

	_tween.tween_property(self, "modulate", color, transition_time)
	

func reset(transition_time: float = 3):
	set_vignette(Color.BLACK, transition_time)
