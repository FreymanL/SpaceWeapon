extends TextureButton

@onready var title = $Title

signal level_selected(level: String)

var level: String
var level_name: String

func _on_pressed():
	emit_signal("level_selected", level)

func load_icon(level_: String):
	level = level_
	level_name = Settings.settings.worlds[level].name
	title.text = level_name
	texture_normal = load("res://images/backgrounds/"+level+"_icon.png")
	texture_hover = load("res://images/backgrounds/"+level+"_icon_focussed.png")
	
	
