extends Button

const create_profile := preload("res://Scenes/CreateNewProfile.tscn")
var exist := false

func _ready():
	if Datastore.get_data().Profiles[int(self.name)].username != "":
		$MC/NewProfile.visible = false
		$MC/VBC.visible = true
		exist = true
		
		$MC/VBC/Username.text = Datastore.get_data().Profiles[int(self.name)].username
		$MC/VBC/ServerName.text = Datastore.get_data().Profiles[int(self.name)].server
		
		# Make the font have the correct size for the card
		var dynfont = DynamicFont.new()
		dynfont.font_data = load("res://Fonts/Lato-Regular.ttf")
		$MC/VBC/Username.add_font_override("font", dynfont)
		var fontsize = 110.0 / ($MC/VBC/Username.text.length() / 2)
		$MC/VBC/Username.get_font("font").size = fontsize

func _on_ProfileCard_pressed():
	if !exist:
		var creation_instance = create_profile.instance()
		creation_instance.selected_profile = self
		get_node("/root").add_child(creation_instance)
	else:
		Datastore.get_data().LastSelectedProfile = int(self.name)
		Datastore.set_data(Datastore.get_data())
		Datastore.save_data()
		get_node("../../../../SelectedProfile").text = "Profile " + Datastore.get_data().Profiles[Datastore.get_data().LastSelectedProfile].username + " is selected"
