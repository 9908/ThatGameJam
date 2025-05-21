extends Node2D

var listen_to_input: bool= true

# Movement settings
const MOVE_SPEED = 400.0
const ACCEL = 3000.0
const DEACCEL = 1400.0

# Jump settings
const JUMP_VELOCITY = -1150.0
const MAX_FALL_VELOCITY = 3500.0
const EXTRA_JUMPS = 1
const GRAVITY = 3100.0
const VARIABLE_JUMP_MULT = 0.95

# Wall jump
const WALL_JUMP_FORCE = Vector2(300, -400)
const WALL_SLIDE_SPEED = 50

# Coyote time and jump buffer
const COYOTE_TIME = 0.15
const JUMP_BUFFER_TIME = 0.1

var jump_count = 0
var coyote_timer = 0.0
var jump_buffer_timer = 0.0
var was_on_floor = false


func _physics_process(delta):
	# Get input
	
	var move_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var on_floor = owner.is_on_floor()
	
	if listen_to_input:
		# Horizontal movement
		if move_input != 0:
			owner.velocity.x = move_toward(owner.velocity.x, move_input * MOVE_SPEED, ACCEL * delta)
		else:
			owner.velocity.x = move_toward(owner.velocity.x, 0, DEACCEL * delta)

	# Coyote time logic
	if on_floor:
		coyote_timer = COYOTE_TIME
		jump_count = 0
		owner.last_save_point.insert(0,owner.global_position)
		owner.last_save_point.resize(60)
	else:
		coyote_timer -= delta

	# Jump buffering
	if Input.is_action_just_pressed("jump") and listen_to_input:
		jump_buffer_timer = JUMP_BUFFER_TIME
	else:
		jump_buffer_timer -= delta

	# Jumping
	if jump_buffer_timer > 0:
		if coyote_timer > 0: 
			owner.velocity.y = JUMP_VELOCITY
			jump_buffer_timer = 0.0
			if not on_floor:
				jump_count += 1

	# Variable jump height
	if not Input.is_action_pressed("jump") and owner.velocity.y < 0 and listen_to_input:
		owner.velocity.y *= VARIABLE_JUMP_MULT

	# Apply gravity
	if not on_floor:
		owner.velocity.y += GRAVITY * delta
		
	# Cap velocity
	if owner.velocity.y > MAX_FALL_VELOCITY:
		owner.velocity.y = MAX_FALL_VELOCITY
		
	# Move the character
	owner.move_and_slide()
	
	var target_camera_pos = 250.0*owner.velocity.normalized()
	if Input.get_action_strength("ui_up"):
		target_camera_pos += Vector2(0, -125)
	elif Input.get_action_strength("ui_down"):
		target_camera_pos += Vector2(0, 125)
	owner.camera_target.position = lerp(owner.camera_target.position, target_camera_pos, 0.1) 
		
	was_on_floor = on_floor
	
	
