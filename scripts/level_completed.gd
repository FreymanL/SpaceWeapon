extends Control

signal go_home

func _process(delta):
	pass

func _on_home_pressed():
	emit_signal("go_home")
