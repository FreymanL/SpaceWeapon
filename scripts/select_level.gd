extends Control

signal level_selected(level)
signal level_selected_canceled()

@onready var world_icon = load("res://scenes/menu_controls/level_icon.tscn")
@onready var worlds_containter = $BackGround/HBoxContainer
@onready var pressed_audio = $BtnPressedAudio

func load_worlds():
	var current_level = UserData.user_data.current_level
	var nodes = worlds_containter.get_children()
	for node in nodes:
		node.queue_free()
	var worlds = Settings.get_key("worlds")
	for world in worlds:
		if worlds[world].num > current_level:
			return
		var world_instance = world_icon.instantiate()
		worlds_containter.add_child(world_instance)
		world_instance.load_icon(world)
		world_instance.connect("level_selected", process_level_selected)

func process_level_selected(level: String):
	emit_signal("level_selected", level)

func _on_back_pressed():
	pressed_audio.play()
	emit_signal("level_selected_canceled")
