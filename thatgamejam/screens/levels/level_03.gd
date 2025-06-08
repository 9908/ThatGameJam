extends BaseLevel


@onready var tutorial_trigger: Area2D = $TutorialTrigger
@onready var blob_5: Node2D = $Props/Blob5


func _on_tutorial_trigger_body_entered(body: Node2D) -> void:
	if body == Globals.player:
		tutorial_trigger.queue_redraw()
		blob_5.explodeded.connect(_on_learned_to_explosion)
		Globals.tutorial.show_text("Yellow blobs explode on contact")


func _on_learned_to_explosion():
	blob_5.explodeded.disconnect(_on_learned_to_explosion)
	Globals.tutorial.learned()
