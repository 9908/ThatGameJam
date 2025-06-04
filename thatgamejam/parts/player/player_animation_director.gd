extends Node2D

@onready var backpack: Node2D = $"../Visual/Backpack"
@onready var sprite: ColorRect = $"../Visual/ColorRect"
@onready var visual: Node2D = $"../Visual"
@onready var body: AnimatedSprite2D = $"../Visual/Anims/Body"
@onready var animation_player_body: AnimationPlayer = $AnimationPlayerBody

var squash_lerp = 30.0
var current_state: String = ""
var previous_velocity := Vector2.ZERO

func _physics_process(delta):
	var is_on_ground = owner.is_on_floor()
	var is_jumping = not is_on_ground and owner.velocity.y < 0
	var is_falling = not is_on_ground and owner.velocity.y > 0
	var started_falling = not is_on_ground and previous_velocity.y < 0 and owner.velocity.y >= 0
	var landed = is_on_ground and previous_velocity.y > 0 and owner.velocity.y == 0 and current_state not in ["Reception", "JumpBeggin", "JumpEnd"]

	if current_state == "Cutting" or current_state == "Growing":
		return
		
	if landed:
		current_state = "Reception"
		if body.animation != "Reception":
			animation_player_body.play("Reception")
		return

	if is_jumping and current_state != "JumpBeggin":
		current_state = "JumpBeggin"
		if body.animation != "JumpBeggin":
			animation_player_body.play("JumpBeggin")
		return

	if started_falling and current_state != "JumpEnd":
		current_state = "JumpEnd"
		if body.animation != "JumpEnd":
			animation_player_body.play("JumpEnd")
		return

	if is_on_ground:
		if abs(owner.velocity.x) > 0.1:
			if current_state != "Walk":
				current_state = "Walk"
				animation_player_body.play("Walk")
		elif current_state not in ["Stop", "IdleA"]:
			current_state = "Stop"
			animation_player_body.play("Stop")

	visual.scale.x = sign(owner.velocity.x) if owner.velocity.x != 0 else visual.scale.x
	previous_velocity = owner.velocity



func _on_body_animation_finished() -> void:
	if current_state == "Stop":
		if owner.velocity.x == 0 and owner.is_on_floor():
			current_state = "IdleA"
			animation_player_body.play("IdleA")
	elif current_state == "Reception":
		if owner.is_on_floor():
			if abs(owner.velocity.x) > 0.1:
				current_state = "Walk"
				animation_player_body.play("Walk")
			else:
				current_state = "IdleA"
				animation_player_body.play("IdleA")
	elif current_state == "Cutting":
		owner.movement.listen_to_input = true
		owner.movement.set_physics_process(true)
		if abs(owner.velocity.x) > 0.1:
			current_state = "Walk"
			animation_player_body.play("Walk")
		else:
			current_state = "IdleA"
			animation_player_body.play("IdleA")
	elif current_state == "Growing":
		if body.animation == "GrowBeggin":
			animation_player_body.play("GrowIdle")
		elif body.animation == "GrowStop":
			current_state = "IdleA"
			animation_player_body.play("IdleA")
			owner.movement.listen_to_input = true
			owner.movement.set_physics_process(true)


func _on_grow_plant_cutted_plant() -> void:
	current_state = "Cutting"
	animation_player_body.play("CutBig")


func _on_grow_plant_started_grow() -> void:
	current_state = "Growing"
	animation_player_body.play("GrowBeggin")


func _on_grow_plant_finished_grow() -> void:
	animation_player_body.play("GrowStop")


func _on_animation_player_body_animation_finished(_anim_name: StringName) -> void:
	if current_state == "Stop":
		if owner.velocity.x == 0 and owner.is_on_floor():
			current_state = "IdleA"
			animation_player_body.play("IdleA")
	elif current_state == "Reception":
		if owner.is_on_floor():
			if abs(owner.velocity.x) > 0.1:
				current_state = "Walk"
				animation_player_body.play("Walk")
			else:
				current_state = "IdleA"
				animation_player_body.play("IdleA")
	elif current_state == "Cutting":
		owner.movement.listen_to_input = true
		owner.movement.set_physics_process(true)
		if abs(owner.velocity.x) > 0.1:
			current_state = "Walk"
			animation_player_body.play("Walk")
		else:
			current_state = "IdleA"
			animation_player_body.play("IdleA")
	elif current_state == "Growing":
		if body.animation == "GrowBeggin":
			animation_player_body.play("GrowIdle")
		elif body.animation == "GrowStop":
			current_state = "IdleA"
			animation_player_body.play("IdleA")
			owner.movement.listen_to_input = true
			owner.movement.set_physics_process(true)
