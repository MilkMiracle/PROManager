extends Node

func _ready():
	var file2Check = File.new()
	var FileExists = file2Check.file_exists("user://data.pck")
	
	if FileExists == false or OS.is_debug_build():
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
	else:
		ProjectSettings.load_resource_pack(ProjectSettings.globalize_path("user://data.pck"), true)
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
