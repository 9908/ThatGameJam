extends ColorRect

var target_alpha = 0.0
var lerp_weight = 0.05

func _ready() -> void:
	Globals.fade = self
	show()
	
	
func fade(new_alpha, new_lerp_weight = 0.05):
	target_alpha = new_alpha
	lerp_weight = new_lerp_weight
	

func _process(delta: float) -> void:
	modulate.a = lerp(modulate.a, target_alpha, lerp_weight)
