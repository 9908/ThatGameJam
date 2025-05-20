extends Control

var first_activation: bool = true
var choose_to_give: bool = false

@onready var rich_text_label: RichTextLabel = $PopUpQuestion/TextContainer/RichTextLabel
@onready var line_edit_give: LineEdit = $PopUpQuestion/LineEditContainer/LineEdit
@onready var line_edit_receive: LineEdit = $PopUpQuestion/ReceiveContainer/LineEdit

@onready var give_or_receive_container: HBoxContainer = $PopUpQuestion/GiveOrReceiveContainer
@onready var question_container: HBoxContainer = $PopUpQuestion/QuestionContainer
@onready var line_edit_container: HBoxContainer = $PopUpQuestion/LineEditContainer
@onready var receive_container: HBoxContainer = $PopUpQuestion/ReceiveContainer
@onready var success_container: HBoxContainer = $PopUpQuestion/SuccessContainer

var activated_codes: Array = []

func _ready() -> void:
	Globals.pop_up_question = self
	rich_text_label.text = "Do you want to give all your remaining light to another player ?"
	hide()
	hide_all_containers()
	question_container.show()
	

func hide_all_containers():
	question_container.hide()
	give_or_receive_container.hide()
	line_edit_container.hide()
	receive_container.hide()
	success_container.hide()
	
		
func set_active(new_val: bool):
	if not first_activation and not choose_to_give:
		visible = new_val
		return
	first_activation = false
	visible = new_val
	if choose_to_give:
		if Globals.player.grow_plant.ressource == 0:
			hide_all_containers()
			receive_container.show()
			rich_text_label.text = "Enter gifted code"
		else:
			hide_all_containers()
			give_or_receive_container.show()
			rich_text_label.text = ""
	

func _on_yes_button_pressed() -> void:
	hide_all_containers()
	line_edit_container.show()
	line_edit_give.text = ""
	update_share_window()
	choose_to_give = true
	

func update_share_window():
	rich_text_label.text = "Give this code to a fellow player to offer your " + str(Globals.player.grow_plant.ressource) + str(" RESSOURCE")
	var code = encode_ressource(Globals.player.grow_plant.ressource)
	Globals.player.grow_plant.remove_ressource(Globals.player.grow_plant.ressource)
	line_edit_give.text = code
	

func encode_ressource(amount: int) -> String:
	var buffer = PackedByteArray()
	buffer.append(amount & 0xFF)
	buffer.append((amount >> 8) & 0xFF)
	return Marshalls.raw_to_base64(buffer)


func decode_ressource(code: String) -> int:
	var buffer = Marshalls.base64_to_raw(code)
	
	if buffer.is_empty() or buffer.size() < 2:
		return 0
	var low_byte = buffer[0]
	var high_byte = buffer[1]
	return low_byte | (high_byte << 8)


func _on_no_button_pressed() -> void:
	set_active(false)
	choose_to_give = false
	Globals.player.set_active(true)


func _on_share_button_button_pressed() -> void:
	OS.shell_open("https://itch.io/jam/tgcxcoreblazer") 


func _on_close_pressed() -> void:
	set_active(false)
	Globals.player.set_active(true)


func _on_give_pressed() -> void:
	hide_all_containers()
	line_edit_container.show()
	line_edit_give.text = ""
	update_share_window()
	

func _on_receive_pressed() -> void:
	hide_all_containers()
	receive_container.show()
	line_edit_receive.text = ""
	rich_text_label.text = "Enter gifted code"


func _on_close_receive_pressed() -> void:
	set_active(false)
	Globals.player.set_active(true)


func _on_activate_code_button_pressed() -> void:
	if activated_codes.has(line_edit_receive.text):
		rich_text_label.text = "Enter a gifted code not already used"
		return
	var decoded_value = decode_ressource(line_edit_receive.text)
	if not decoded_value == 0:
		activated_codes.append(line_edit_receive.text)
		Globals.player.grow_plant.get_ressource(decoded_value)
		rich_text_label.text = "Successfully received " + str(decoded_value) + " --- Amazing !"
		hide_all_containers()
		success_container.show()
