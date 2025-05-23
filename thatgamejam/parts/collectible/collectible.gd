extends Node2D

signal collectid

func collected():
	collectid.emit()
	queue_free()
