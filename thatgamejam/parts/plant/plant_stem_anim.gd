extends AnimatedSprite2D

var target_frame = -1

func play_until_frame(animation_name: String, frame: int):
	target_frame = frame
	play()


func _process(delta):
	if frame >= target_frame:
		set_process(false)
		stop()
		frame = target_frame  
	else:
		play()
