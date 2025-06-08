extends Node2D

func move_to(new_pos):
	scale = Vector2.ZERO
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "scale", Vector2.ONE, 0.5)
	tween.tween_property(self, "global_position", new_pos, 1.0)
