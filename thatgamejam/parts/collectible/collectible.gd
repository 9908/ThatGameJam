extends Node2D

signal collectid

func collected():
	collectid.emit()
	## FLAG-SFX done "Sfx_PlayerPickup"
	FmodServer.play_one_shot("event:/rhode")
	# Plays Once when the player collects a grain : "Sfx_PlayerPickup"
	queue_free()
