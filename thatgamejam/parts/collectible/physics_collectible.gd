extends RigidBody2D


func _on_collectible_collectid() -> void:
	queue_free()
