extends Node2D

var player_scn = preload("res://parts/player/player.tscn")
@onready var player_start_pos: Marker2D = $PlayerStartPos

func _ready() -> void:
	Globals.level = self


func _enter_tree() -> void:
	await get_tree().create_timer(0.5).timeout
	if Globals.player == null:
		var player = player_scn.instantiate()
		Globals.agents.add_child(player)
	Globals.player.global_position = player_start_pos.global_position
	Globals.camera.set_process(true)
	Globals.camera.set_target(Globals.player)
