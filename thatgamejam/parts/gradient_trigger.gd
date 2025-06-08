extends Area2D

@export var one_shot: bool = false
@export var time_of_day: float = 1.0
@export var transition_time: float = 3.0

func _on_body_entered(body: Node2D) -> void:
	if body == Globals.player:
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_LINEAR)
		tween.set_ease(Tween.EASE_IN_OUT)

		tween.tween_property(Globals.dynamic_background, "day_progress", time_of_day, transition_time)  
		tween.tween_callback(Callable(self, "_on_tween_finished"))

			
func _set(property: StringName, value: Variant) -> bool:
	if property == "tweened_value":
		Globals.dynamic_background.set_day_progress(value)
		return true
	return false


func _on_tween_finished():
	if one_shot:
		queue_free()
