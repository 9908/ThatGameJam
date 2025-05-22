extends Node2D

var player_scn = preload("res://parts/player/player.tscn")
@onready var player_start_pos: Marker2D = $PlayerStartPos
@export var time_of_day: float = 0

func _ready() -> void:
	Globals.level = self


func _enter_tree() -> void:
	await get_tree().process_frame
	Globals.dynamic_background.set_day_progress(time_of_day)
	if Globals.player == null:
		var player = player_scn.instantiate()
		Globals.main.add_child(player)
	Globals.player.global_position = player_start_pos.global_position
	Globals.camera.set_process(true)
	Globals.camera.set_target(Globals.player.camera_target)
	await get_tree().process_frame
	Globals.camera.teleport_position()


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Globals.pause_menu.toggle()
