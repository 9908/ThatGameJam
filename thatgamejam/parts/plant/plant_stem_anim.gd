extends AnimatedSprite2D

var target_frame = -1
var stop_at_frame = false
var can_wiggle: bool = false

func play_until_frame(frame: int = 61):
	can_wiggle = false
	target_frame = frame
	stop_at_frame = true
	play()


func _process(delta):
	if stop_at_frame and frame >= target_frame:
		set_process(false)
		pause()
		frame = target_frame  
		stop_at_frame = false
		can_wiggle = true
	else:
		play()


func stop_anim():
	target_frame = frame
	stop_at_frame = true
	set_process(true)
	

func wiggle():
	if not can_wiggle:
		return
	if target_frame - 3 >= 0:
		set_process(false)
		
		frame = target_frame - 1
		await get_tree().create_timer(0.035).timeout
		if not can_wiggle:
			frame = target_frame
			return
		frame = target_frame - 2
		await get_tree().create_timer(0.035).timeout
		if not can_wiggle:
			frame = target_frame
			return
		frame = target_frame - 3
		await get_tree().create_timer(0.05).timeout
		if not can_wiggle:
			frame = target_frame
			return
		frame = target_frame - 2
		await get_tree().create_timer(0.05).timeout
		if not can_wiggle:
			frame = target_frame
			return
		frame = target_frame - 1
		await get_tree().create_timer(0.05).timeout
		if not can_wiggle:
			frame = target_frame
			return
		frame = target_frame
		stop_at_frame = true
		set_process(true)
	elif target_frame - 2 >= 0:
		set_process(false)
		frame = target_frame - 1
		await get_tree().create_timer(0.035).timeout
		if not can_wiggle:
			frame = target_frame
			return
		frame = target_frame - 2
		await get_tree().create_timer(0.05).timeout
		if not can_wiggle:
			frame = target_frame
			return
		frame = target_frame - 1
		await get_tree().create_timer(0.05).timeout
		if not can_wiggle:
			frame = target_frame
			return
		frame = target_frame
		stop_at_frame = true
		set_process(true)
	elif target_frame - 1 >= 0:
		set_process(false)
		frame = target_frame - 1
		await get_tree().create_timer(0.05).timeout
		if not can_wiggle:
			frame = target_frame
			return
		frame = target_frame
		stop_at_frame = true
		set_process(true)
