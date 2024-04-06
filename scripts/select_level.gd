extends Control

signal level_selected(level)
signal level_selected_canceled()



func _ready():
	pass

func _process(delta):
	pass

func _on_level_1_btn_pressed():
	var level = "mundo"
	emit_signal("level_selected", "mundo")

func _on_back_pressed():
	emit_signal("level_selected_canceled")
