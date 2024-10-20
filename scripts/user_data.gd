extends Node

const file_path = "user://SAVEFILE.save"

var user_data: Dictionary = {
	"gold": 100000,
	"ability_points": 0,
	"abilities": {
	},
	"current_level": 5,
	"music_volume": 71,
	"sound_effect_volume": 71,
	"menu_effect_volume": 71
}

func _ready():
	load_data()

func load_data():
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		save_data()
	else:
		user_data = file.get_var()
	save_data()
	file = null

func save_data():
	var file = FileAccess.open(file_path,FileAccess.WRITE)
	file.store_var(user_data)
	file = null

