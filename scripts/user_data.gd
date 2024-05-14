extends Node

const file_path = "user://SAVEFILE.save"

var user_data: Dictionary = {
	"gold": 20000,
	"ability_points": 0,
	"abilities": {
		"super_shoot": true,
	},
	"current_level": 1,
	
}
# Called when the node enters the scene tree for the first time.
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

