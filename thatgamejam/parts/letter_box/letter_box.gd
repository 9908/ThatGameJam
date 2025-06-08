extends Node2D

var player_nearby: bool = false
@onready var animated_sprite: AnimatedSprite2D = $Visual/AnimatedSprite


func _physics_process(_delta):
	if (Input.is_action_just_pressed("grow") or Input.is_action_just_pressed("cut")) and player_nearby:
		Globals.pop_up_question.set_active(true)
		animated_sprite.frame = 0
		animated_sprite.play("default")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == Globals.player:
		player_nearby = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == Globals.player:
		player_nearby = false
