extends Node2D

@onready var level_list_container = $LevelListContainer
const LEVELS_PATH = "res://screens/levels/"

func _ready():
	populate_level_buttons()


func populate_level_buttons():
	var dir = DirAccess.open(LEVELS_PATH)
	if dir == null:
		push_error("Could not open levels folder")
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tscn"):
			var level_path = LEVELS_PATH + "/" + file_name
			create_level_button(level_path)
		file_name = dir.get_next()
	dir.list_dir_end()


func create_level_button(level_path: String):
	var button = Button.new()
	button.text = level_path.get_file().get_basename()
	button.pressed.connect(load_level.bind(level_path))
	level_list_container.add_child(button)


func load_level(level_path: String):
	var level_scene = load(level_path)
	if level_scene:
		var level_instance = level_scene.instantiate()
		owner.add_child(level_instance)
	queue_free()
