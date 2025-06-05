extends AnimatedSprite2D

@onready var line_2d: Line2D = $Line2D
@onready var plant_side_stem_anim: AnimatedSprite2D = $"."

func set_line_2d(x, y):
	line_2d.points[0] = Vector2(0, 0)
	line_2d.points[1] = Vector2(0, y)/plant_side_stem_anim.scale
	line_2d.points[2] = Vector2(x, y)/plant_side_stem_anim.scale
	
