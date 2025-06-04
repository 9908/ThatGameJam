extends AnimatedSprite2D

var target_frame = -1
var stop_at_frame = false

func play_until_frame(animation_name: String, frame: int):
	target_frame = frame
	stop_at_frame = true
	play(animation_name)


func _process(delta):
	if stop_at_frame and frame >= target_frame:
		stop()
		frame = target_frame  # Optional: hold on this frame
		stop_at_frame = false
