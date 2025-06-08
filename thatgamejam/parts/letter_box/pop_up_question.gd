extends Control

var first_activation: bool = true
var choose_to_give: bool = true

@onready var rich_text_label: RichTextLabel = $PopUpQuestion/TextContainer/RichTextLabel
@onready var line_edit_give: LineEdit = $PopUpQuestion/LineEditContainer/LineEdit
@onready var line_edit_receive: LineEdit = $PopUpQuestion/ReceiveContainer/LineEdit

@onready var give_or_receive_container: HBoxContainer = $PopUpQuestion/GiveOrReceiveContainer
@onready var question_container: HBoxContainer = $PopUpQuestion/QuestionContainer
@onready var line_edit_container: HBoxContainer = $PopUpQuestion/LineEditContainer
@onready var receive_container: HBoxContainer = $PopUpQuestion/ReceiveContainer
@onready var success_container: HBoxContainer = $PopUpQuestion/SuccessContainer

@onready var yes_button: Button = $PopUpQuestion/QuestionContainer/YesButton
@onready var share_button_button: Button = $PopUpQuestion/LineEditContainer/ShareButtonButton
@onready var activate_code_button: Button = $PopUpQuestion/ReceiveContainer/ActivateCodeButton
@onready var give: Button = $PopUpQuestion/GiveOrReceiveContainer/Give
@onready var close_receive: Button = $PopUpQuestion/SuccessContainer/CloseReceive


var activated_codes: Array = []

func _ready() -> void:
	Globals.pop_up_question = self
	rich_text_label.text = "Do you want to send all your stars to another player ?"
	hide()
	hide_all_containers()
	question_container.show()
	yes_button.grab_focus()
	

func hide_all_containers():
	question_container.hide()
	give_or_receive_container.hide()
	line_edit_container.hide()
	receive_container.hide()
	success_container.hide()
	
		
func set_active(new_val: bool):
	visible = new_val
	Globals.player.set_active(not new_val)
	Globals.player.velocity.x = 0
	yes_button.grab_focus()
	if not first_activation and not choose_to_give:
		return
	# FLAG-SFX - mailbox
	FmodServer.play_one_shot("event:/mailbox")
		
	first_activation = false
	if choose_to_give:
		if Globals.player.grow_plant.ressource == 0:
			hide_all_containers()
			receive_container.show()
			activate_code_button.grab_focus()
			line_edit_receive.text = ""
			rich_text_label.text = "Enter gifted code"
		else:
			hide_all_containers()
			give_or_receive_container.show()
			give.grab_focus()
			rich_text_label.text = "Do you want to send all your stars to another player ?"
	

func _on_yes_button_pressed() -> void:
	hide_all_containers()
	line_edit_container.show()
	share_button_button.grab_focus()
	line_edit_give.text = ""
	update_share_window()
	

func update_share_window():
	rich_text_label.text = "Share this code to a fellow player to offer your " + str(Globals.player.grow_plant.ressource) + str(" stars")
	var code = encode_donation(Globals.player.grow_plant.ressource)
	Globals.player.grow_plant.remove_ressource(Globals.player.grow_plant.ressource)
	line_edit_give.text = code
	activated_codes.append(code)
	# FLAG-SFX - give gift
	FmodServer.play_one_shot("event:/give_gift")
	# TODO
	

func encode_donation(light: int) -> String:
	var username = "Player"
	if OS.has_environment("USERNAME"):
		username = OS.get_environment("USERNAME")

	var data := {
		"user": username,
		"time": Time.get_datetime_string_from_system(),  
		"light": light
	}

	var json_string = JSON.stringify(data)
	var byte_array = json_string.to_utf8_buffer()
	return Marshalls.raw_to_base64(byte_array)


func decode_donation(code: String) -> Dictionary:
	var byte_array = Marshalls.base64_to_raw(code)
	if byte_array.is_empty():
		return {}

	var json_string = byte_array.get_string_from_utf8()
	var result= JSON.parse_string(json_string)
	
	if result == null or not result is Dictionary:
		return {}

	return result


func _on_no_button_pressed() -> void:
	set_active(false)
	Globals.player.set_active(true)
	choose_to_give = true


func _on_share_button_button_pressed() -> void:
	OS.shell_open("https://itch.io/jam/tgcxcoreblazer") 


func _on_close_pressed() -> void:
	set_active(false)
	Globals.player.set_active(true)


func _on_give_pressed() -> void:
	hide_all_containers()
	line_edit_container.show()
	share_button_button.grab_focus()
	line_edit_give.text = ""
	update_share_window()
	

func _on_receive_pressed() -> void:
	hide_all_containers()
	receive_container.show()
	activate_code_button.grab_focus()
	line_edit_receive.text = ""
	rich_text_label.text = "Enter gifted code"


func _on_close_receive_pressed() -> void:
	set_active(false)
	Globals.player.set_active(true)


func _on_activate_code_button_pressed() -> void:
	if activated_codes.has(line_edit_receive.text):
		rich_text_label.text = "Enter a gifted code not already used"
		return
	var decoded_value = decode_donation(line_edit_receive.text)

	if decoded_value.has("light"):
		if not decoded_value.light == 0:
			activated_codes.append(line_edit_receive.text)
			Globals.player.grow_plant.get_ressource(decoded_value.light)
			rich_text_label.text = "Successfully received " + str(decoded_value.light) + " stars --- Amazing !"
			hide_all_containers()
			success_container.show()
			close_receive.grab_focus()
			
			# FLAG-SFX - receive gift
			FmodServer.play_one_shot("event:/receive_gift")
			# TODO
	else:
		rich_text_label.text = "Enter a valid code"
