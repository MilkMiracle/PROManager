extends Node

const SAVE_LOCATION := "user://data.save"
const DEBUG_SAVE_LOCATION := "user://debug_data.save"

var default_data = {
	"LastSelectedProfile": 0,
	"Profiles": [
		{
			"username": "",
			"server": "",
			"user_data": []
		},
		{
			"username": "",
			"server": "",
			"user_data": []
		},
		{
			"username": "",
			"server": "",
			"user_data": []
		},
		{
			"username": "",
			"server": "",
			"user_data": []
		}
	]
}

var _data = {} setget set_data, get_data

func set_data(new_data):
	_data = new_data

func get_data():
	return _data

func save_data():
	var file = File.new()
	if OS.is_debug_build():
		file.open(DEBUG_SAVE_LOCATION, File.WRITE)
	else:
		file.open(SAVE_LOCATION, File.WRITE)
	file.store_string(var2str(_data))
	file.close()

func load_data():
	var file = File.new()
	if OS.is_debug_build():
		file.open(DEBUG_SAVE_LOCATION, File.READ)
	else:
		file.open(SAVE_LOCATION, File.READ)
	var content = file.get_as_text()
	file.close()
	
	if content:
		_data = str2var(content)
	else:
		_data = default_data.duplicate(true)

func _ready():
	load_data()
