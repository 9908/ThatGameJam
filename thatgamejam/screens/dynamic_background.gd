@tool
extends Node

@export var gradients: Array[Gradient] = []
@export_range(0.0, 9.999, 0.01) var day_progress: float = 0.0 : set = set_day_progress
@export_node_path("TextureRect") var color_rect_path: NodePath

var blended_gradient := Gradient.new()
var gradient_texture := GradientTexture1D.new()
var color_rect: TextureRect

func _ready():
	setup_gradient()
	Globals.dynamic_background = self


func setup_gradient():
	if color_rect_path.is_empty():
		return

	if not is_instance_valid(color_rect):
		color_rect = get_node_or_null(color_rect_path)
		if color_rect == null:
			return

	gradient_texture.gradient = blended_gradient
	gradient_texture.width = 256

	color_rect.texture = gradient_texture
	update_gradient()


func set_day_progress(value: float):
	day_progress = value
	if Engine.is_editor_hint():
		update_gradient()
	else:
		call_deferred("update_gradient")


func update_gradient():
	if gradients.size() < 2:
		return

	var index_a = floori(day_progress)
	var index_b = clamp(index_a + 1, 0, gradients.size() - 1)
	var t = day_progress - index_a

	var grad_a = gradients[index_a]
	var grad_b = gradients[index_b]

	if grad_a.get_point_count() != grad_b.get_point_count():
		return

	var new_offsets = PackedFloat32Array()
	var new_colors = PackedColorArray()

	for i in grad_a.get_point_count():
		var offset = lerp(grad_a.get_offset(i), grad_b.get_offset(i), t)
		var color = grad_a.get_color(i).lerp(grad_b.get_color(i), t)
		new_offsets.append(offset)
		new_colors.append(color)

	blended_gradient.set_offsets(new_offsets)
	blended_gradient.set_colors(new_colors)

	gradient_texture.gradient = blended_gradient
	color_rect.texture = gradient_texture
