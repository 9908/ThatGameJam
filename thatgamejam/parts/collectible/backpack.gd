extends Node2D

@onready var backpack_ressources = $RessourceVisualisation
var backpack_ressource_scn = preload("res://parts/collectible/backpack_ressource_visualisation.tscn")

var area_size = 35.0

func _ready():
	update_layout()
	
	
func add():
	var new_ressource = backpack_ressource_scn.instantiate()
	backpack_ressources.add_child(new_ressource)
	call_deferred("update_layout")
	
	
func remove():
	var backpack_size = backpack_ressources.get_children().size()
	if backpack_size == 0:
		return
	backpack_ressources.get_child(0).queue_free()
	call_deferred("update_layout")


func update_layout():
	var count = backpack_ressources.get_children().size()
	if count == 0:
		return

	var max_radius = 0.0
	
	var columns = ceil(sqrt(count))
	var rows = ceil(count / columns)

	var cell_width = area_size / columns
	var cell_height = area_size / rows
	var diameter = min(cell_width, cell_height)
	var radius = diameter * 0.5
	max_radius = radius

	for i in count:
		var row = float(i) / columns
		var col = fmod(float(i), columns)
		var x = (col + 0.5) * cell_width
		var y = (row + 0.5) * cell_height
		var asset = backpack_ressources.get_child(i)
		if count == 1:
			asset.position = Vector2.ZERO
			asset.scale = Vector2.ONE
		else:
			asset.position = Vector2(x, y) - Vector2.ONE * 35.0 * 0.5  
			asset.scale = Vector2(diameter, diameter) / 35.0          
