extends Node2D

signal collectid

func collected():
	collectid.emit()
	## FLAG-SFX "Sfx_PlayerPickup"
	# Plays Once when the player collects a grain : "Sfx_PlayerPickup"
	queue_free()
