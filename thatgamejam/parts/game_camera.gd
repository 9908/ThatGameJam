extends Camera2D

@onready var phantom_camera_2d: PhantomCamera2D = $"../PhantomCamera2D"
@onready var phantom_camera_host: PhantomCameraHost = $PhantomCameraHost

func _ready() -> void:
	Globals.camera = self
	set_process(false)
	

func _process(_delta: float) -> void:
	phantom_camera_2d.follow_damping_value = Vector2.ONE * 0.5 * (1 - (Globals.player.velocity.y / Globals.player.movement.MAX_FALL_VELOCITY))
	
	
func set_target(new_target):
	phantom_camera_2d.follow_target = new_target
