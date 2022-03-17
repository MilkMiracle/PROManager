extends Panel

export(String, "Dig", "Tree", "Pokestop", "Bosses", "Daily") var Action
export var areaName := "Route 1"
export var cooldown_sec := 259200

var itemindex = 0
var indexcount = 0
var exist = false

func calculate_time_left(current_unix_time:int):
	var time_left = (int(Datastore.get_data().Profiles[Datastore.get_data().LastSelectedProfile].user_data[itemindex][2]) + cooldown_sec) - current_unix_time
	var result := ""
	if time_left <= 0:
		result = "Ready"
		$VBC/HBC/Done.visible = true
		$VBC/HBC/Reset.visible = false
	else:
		$VBC/HBC/Done.visible = false
		$VBC/HBC/Reset.visible = true
		var hour = time_left / 3600
		var minute = (time_left - (3600 * hour)) / 60
		var second = time_left - (3600 * hour) - (60 * minute)
		result = str(hour) + ":" + str(minute) + ":" + str(second)
	return result

func _ready():
	$VBC/Area.text = areaName
	for profile in Datastore.get_data().Profiles:
		indexcount = 0
		for data in profile.user_data:
			if data.has(Action) && data.has(areaName):
				exist = true
				itemindex = indexcount
				if str(data[2]) != "Ready":
					$VBC/HBC/Cooldown.text = calculate_time_left(OS.get_unix_time())
					$VBC/HBC/Done.visible = false
					$VBC/HBC/Reset.visible = true
				else:
					$VBC/HBC/Cooldown.text = "Ready"
			indexcount += 1
		if !exist:
			profile.user_data.append([Action, areaName, "Ready"])
			itemindex = Datastore.get_data().Profiles[Datastore.get_data().LastSelectedProfile].user_data.size() - 1
			$VBC/HBC/Cooldown.text = "Ready"

func _process(_delta):
	$VBC/HBC/Cooldown.text = calculate_time_left(OS.get_unix_time())

func _on_Done_pressed():
	Datastore.get_data().Profiles[Datastore.get_data().LastSelectedProfile].user_data[itemindex] = [Action, areaName, OS.get_unix_time()]
	Datastore.set_data(Datastore.get_data())
	Datastore.save_data()
	
	$VBC/HBC/Cooldown.text = calculate_time_left(OS.get_unix_time())
	$VBC/HBC/Done.visible = false
	$VBC/HBC/Reset.visible = true

func _on_Reset_pressed():
	$VBC/HBC/Cooldown.text = "Ready"
	$VBC/HBC/Done.visible = true
	$VBC/HBC/Reset.visible = false
	
	Datastore.get_data().Profiles[Datastore.get_data().LastSelectedProfile].user_data[itemindex] = [Action, areaName, "Ready"]
	Datastore.set_data(Datastore.get_data())
	Datastore.save_data()

func _on_Edit_pressed():
	OS.shell_open("https://wiki.pokemonrevolution.net/index.php?title=Xylos_(boss)")

