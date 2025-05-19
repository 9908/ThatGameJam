extends Node2D

@onready var sprite: ColorRect = $"../ColorRect"
@onready var movement: Node2D = $"../Abilities/Movement"

var squash_lerp = 30.0


func _physics_process(delta):
	if Input.is_action_just_pressed("jump"):
		squash_lerp = 1.0
		sprite.scale = Vector2(1.35, 0.65)  
	apply_squash_and_stretch(delta)
	
	
func apply_squash_and_stretch(delta):
	var target_scale = Vector2.ONE
	var target_rotation = 0.0
	
	if not owner.is_on_floor():
		target_rotation = 10.0 * owner.velocity.x / movement.MOVE_SPEED 
	else:
		target_rotation = 2.5 * owner.velocity.x / movement.MOVE_SPEED
		
	if not movement.was_on_floor and owner.is_on_floor():
		sprite.scale = Vector2(1.35, 0.65)  # Snap squash on land
		squash_lerp = 10.0
	elif owner.velocity.y < 0:
		target_scale = abs(owner.velocity.y) * Vector2(0.15, -0.15) / movement.JUMP_VELOCITY + Vector2.ONE
	else:
		target_scale = abs(owner.velocity.y) * Vector2(0.3, -0.3) / movement.JUMP_VELOCITY + Vector2.ONE
	
	target_rotation *= owner.velocity.y/movement.JUMP_VELOCITY
	

	squash_lerp = lerp(squash_lerp, 30.0, delta)
	sprite.scale = sprite.scale.lerp(target_scale, delta * squash_lerp)
	sprite.rotation_degrees = lerp(sprite.rotation_degrees, target_rotation, delta * squash_lerp)
