extends Node2D

var player_scn = preload("res://parts/player/player.tscn")
@onready var player_start_pos: Marker2D = $PlayerStartPos
@export var time_of_day: float = 0

func _ready() -> void:
	Globals.level = self
	Globals.props = $Props

func _enter_tree() -> void:
	await get_tree().process_frame
	Globals.dynamic_background.set_day_progress(time_of_day)
	if Globals.player == null:
		var player = player_scn.instantiate()
		Globals.agents.add_child(player)
		Globals.player.grow_plant.get_ressource(Globals.ressource)
	Globals.player.global_position = player_start_pos.global_position
	Globals.camera.set_process(true)
	Globals.camera.set_target(Globals.player.camera_target)
	await get_tree().process_frame
	Globals.camera.teleport_position()
	
	
	
	FmodServer.set_global_parameter_by_name("area",0.0)
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Globals.pause_menu.toggle()


func _process(_delta):
	var cam := get_viewport().get_camera_2d()
	if cam == null:
		return

	var mat = material
	mat.set_shader_parameter("camera_y", -cam.global_position.y)
