extends BaseLevel

@onready var tutorial_trigger: Area2D = $TutorialTrigger


func _on_tutorial_trigger_body_entered(body: Node2D) -> void:
	if body == Globals.player:
		tutorial_trigger.queue_free()
		Globals.player.grow_plant.cutted_plant.connect(_on_learned_to_cut)
		Globals.tutorial.show_text("E to cut a plant")


func _on_learned_to_cut():
	Globals.player.grow_plant.cutted_plant.disconnect(_on_learned_to_cut)
	Globals.tutorial.learned()
