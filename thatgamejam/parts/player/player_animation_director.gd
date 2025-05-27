extends Node2D

@onready var backpack: Node2D = $"../Visual/Backpack"
@onready var sprite: ColorRect = $"../Visual/ColorRect"
@onready var visual: Node2D = $"../Visual"
@onready var body: AnimatedSprite2D = $"../Visual/Anims/Body"

var squash_lerp = 30.0


func _physics_process(delta):
	if owner.grow_plant.growing:
		sprite.scale = Vector2(1.35, 0.65)
		
	if Input.is_action_just_pressed("jump"):
		squash_lerp = 1.0  
		
	apply_squash_and_stretch(delta)
	if not owner.velocity.x == 0:
		visual.scale.x = sign(owner.velocity.x)
		body.play("Walk")
	else:
		body.pause()
	
	
func apply_squash_and_stretch(delta):
	var target_scale = Vector2.ONE
	var target_rotation = 0.0
	
	if not owner.is_on_floor():
		target_rotation = 10.0 * owner.velocity.x / owner.movement.MOVE_SPEED 
	else:
		target_rotation = 2.5 * owner.velocity.x / owner.movement.MOVE_SPEED
		
	if not owner.movement.was_on_floor and owner.is_on_floor():
		sprite.scale = Vector2(1.35, 0.65)  
		squash_lerp = 10.0
	elif owner.velocity.y < 0:
		target_scale = abs(owner.velocity.y) * Vector2(0.15, -0.15) / owner.movement.JUMP_VELOCITY + Vector2.ONE
	else:
		target_scale = abs(owner.velocity.y) * Vector2(0.3, -0.3) / owner.movement.JUMP_VELOCITY + Vector2.ONE
	
	target_rotation *= owner.velocity.y/owner.movement.JUMP_VELOCITY
	

	squash_lerp = lerp(squash_lerp, 30.0, delta)
	sprite.scale = sprite.scale.lerp(target_scale, delta * squash_lerp)
	sprite.rotation_degrees = lerp(sprite.rotation_degrees, target_rotation, delta * squash_lerp)
