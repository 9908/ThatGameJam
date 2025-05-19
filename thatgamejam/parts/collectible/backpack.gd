extends Node2D

@onready var ressource_visualisations = $RessourceVisualisation.get_children()

func _ready() -> void:
	set_value(0)
	
	
func set_value(value: int):
	var counter: int = 0
	for visualisation in ressource_visualisations:
		counter += 1
		visualisation.visible = counter < value
