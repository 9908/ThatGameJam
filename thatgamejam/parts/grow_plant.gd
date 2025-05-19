extends Node2D


func _physics_process(delta):
	if Input.is_action_just_pressed("grow"):
		start_growing()
	elif Input.is_action_just_released("grow"):
		stop_growing()


func start_growing():
	pass


func stop_growing():
	pass
