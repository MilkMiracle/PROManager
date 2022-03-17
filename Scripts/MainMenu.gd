extends Control

var Version := "0.5"
var UpdatedVersion := ""
var FirstRequest := true

func _ready():
	var dataExist = File.new()
	var location := ""
	if OS.is_debug_build():
		location = Datastore.DEBUG_SAVE_LOCATION
	else:
		location = Datastore.SAVE_LOCATION
	var DataExists = dataExist.file_exists(location)
	if DataExists:
		$TabContainer.tabs_visible = true
		$TabContainer/Profiles/VBC/CC/VBC/SelectProfile.visible = false
		$TabContainer/Profiles/VBC/SelectedProfile.visible = true
		$TabContainer/Profiles/VBC/SelectedProfile.text = "Profile " + Datastore.get_data().Profiles[Datastore.get_data().LastSelectedProfile].username + " is selected"
	$TabContainer/Profiles/VBC/VBC/HBC/Version.text = "Version " + Version
	
	# Check for an update
	if !OS.is_debug_build():
		$HTTPRequest.connect("request_completed", self, "_on_request_completed")
		$HTTPRequest.request("https://raw.githubusercontent.com/Kizuna-dev/PROmanager/main/Versions/Version.txt")

func _on_request_completed(_result, response_code, _headers, body):
	if response_code == 200 and body.get_string_from_utf8() != Version and FirstRequest == true:
		$TabContainer/Profiles/VBC/VBC/HBC/Update.visible = true
		UpdatedVersion = body.get_string_from_utf8()
		FirstRequest = false
		return
	
	if response_code == 200 and FirstRequest == false:
		var file = File.new()
		file.open("user://data.pck", File.WRITE)
		file.store_buffer(body)
		file.close()
		
		ProjectSettings.load_resource_pack(ProjectSettings.globalize_path("user://data.pck"), true)
		get_tree().change_scene("res://Loader.tscn")

func _on_Update_pressed():
	$HTTPRequest.request("https://github.com/Kizuna-dev/PROmanager/raw/main/Versions/" + UpdatedVersion + "/data.pck")

func _on_Wiki_pressed():
	OS.shell_open("https://wiki.pokemonrevolution.net/")

func _on_Discord_pressed():
	OS.shell_open("https://discord.gg/98pMNxq")
