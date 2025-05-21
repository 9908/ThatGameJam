extends Control

var active: bool = false

func _ready() -> void:
	set_active(false)
	Globals.pause_menu = self
	

func toggle():
	set_active(not active)
	
	
func set_active(new_val):
	active = new_val
	visible = new_val
	get_tree().paused = active


func _on_resume_button_pressed() -> void:
	set_active(false)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
