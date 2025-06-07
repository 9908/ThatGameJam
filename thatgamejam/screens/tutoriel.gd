extends RichTextLabel

var learned_tutorial: bool = false
var tween

func _ready():
	Globals.tutorial = self
	modulate.a = 0
	
	
func show_text(new_text: String, frustration_time: float = 7.5):
	text = new_text
	learned_tutorial = false
	await get_tree().create_timer(frustration_time).timeout
	if not learned_tutorial:
		if tween:
			tween.kill()
		tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
		tween.tween_property(self, "modulate:a", 1.0, 2.5)


func learned():
	learned_tutorial = true
	if tween:
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate:a", 0.0, 1.5)
