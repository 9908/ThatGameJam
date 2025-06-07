extends Control

var active: bool = false
@onready var resume_button: Button = $QuestionContainer/ResumeButton
@onready var quit_button: Button = $QuestionContainer/QuitButton

func _ready() -> void:
	set_active(false)
	Globals.pause_menu = self
	

func toggle():
	set_active(not active)
	
	
func set_active(new_val):
	active = new_val
	visible = new_val
	get_tree().paused = active
	resume_button.grab_focus()
	if is_instance_valid(Globals.player):
		Globals.player.set_active(not active)


func _on_resume_button_pressed() -> void:
	set_active(false)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
