extends ColorRect

var target_alpha = 0.0

func _ready() -> void:
	Globals.fade = self
	show()
	
	
func fade(new_alpha):
	target_alpha = new_alpha
	

func _process(delta: float) -> void:
	modulate.a = lerp(modulate.a, target_alpha, 0.05)
