extends Camera2D

@onready var phantom_camera_2d: PhantomCamera2D = $"../PhantomCamera2D"
@onready var phantom_camera_host: PhantomCameraHost = $PhantomCameraHost

var tween

func _ready() -> void:
	Globals.camera = self
	set_process(false)
	

func _process(_delta: float) -> void:
	phantom_camera_2d.follow_damping_value = Vector2.ONE * 0.5 * (1 - (Globals.player.velocity.y / Globals.player.movement.MAX_FALL_VELOCITY))
	
	
func set_target(new_target):
	phantom_camera_2d.follow_target = new_target


func set_new_zoom(new_val):
	var tween 
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(phantom_camera_2d, "zoom", new_val, 3.5)


func teleport_position():
	phantom_camera_2d.teleport_position()


func set_boundaries(left, right, top, bottom):
	phantom_camera_2d.limit_left = left.global_position.x
	phantom_camera_2d.limit_right = right.global_position.x
	phantom_camera_2d.limit_bottom = bottom.global_position.y
	phantom_camera_2d.limit_top = top.global_position.y


func set_screenshake(value= 100, time = 1):
	phantom_camera_2d.noise.amplitude = value
	if tween:
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(phantom_camera_2d.noise, "amplitude", 0.0, time)
