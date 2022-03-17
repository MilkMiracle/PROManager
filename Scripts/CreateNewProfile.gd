extends Control

var selected_profile
var selected_server = "Silver"

func _on_Silver_pressed():
	if $MC/VBC/HBC/Gold.pressed == true:
		$MC/VBC/HBC/Gold.pressed = false
		$MC/VBC/HBC/Gold.disabled = false
	$MC/VBC/HBC/Silver.disabled = true
	selected_server = "Silver"

func _on_Gold_pressed():
	if $MC/VBC/HBC/Silver.pressed == true:
		$MC/VBC/HBC/Silver.pressed = false
		$MC/VBC/HBC/Silver.disabled = false
	$MC/VBC/HBC/Gold.disabled = true
	selected_server = "Gold"

func _on_Create_pressed():
	# PRO minimum name length is 3, and max 15
	if $MC/VBC/username.text.length() < 3 and $MC/VBC/username.text.length() > 15:
		pass
	else:
		Datastore.get_data().Profiles[int(selected_profile.name)].username = $MC/VBC/username.text
		Datastore.get_data().Profiles[int(selected_profile.name)].server = selected_server
		Datastore.get_data().LastSelectedProfile = int(selected_profile.name)
		Datastore.set_data(Datastore.get_data())
		Datastore.save_data()
	get_node(selected_profile.get_path())._ready()
	get_node("/root/MainMenu/TabContainer").tabs_visible = true
	get_node("/root/MainMenu/TabContainer/Profiles/VBC/SelectedProfile").text = "Profile " + Datastore.get_data().Profiles[Datastore.get_data().LastSelectedProfile].username + " is selected"
	self.queue_free()

func _on_Back_pressed():
	self.queue_free()
