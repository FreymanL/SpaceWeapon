extends Control

signal go_home
signal play_world(parameters)

@onready var try_again_btn = $"PositionReference/BackGround/ButtonsContainer/TryAgain"

var parameters = {}

func _ready():
	try_again_btn.grab_focus()

func _on_try_again_pressed():
	emit_signal("play_world",parameters)

func set_parameters(para):
	parameters = para

func _on_go_home_pressed():
	emit_signal("go_home")
	

