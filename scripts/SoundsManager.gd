extends Node2D


func _process(_delta):
	UserData.load_data()
	set_music_volume(UserData.user_data.music_volume)
	set_sound_effect_volume(UserData.user_data.sound_effect_volume)
	set_menu_sound_volume(UserData.user_data.menu_effect_volume)

func set_music_volume(value_percentage):
	var min_volume = -25
	var max_volume = 10
	var music_sound_nodes = get_tree().get_nodes_in_group("Music")
	set_sound_to_nodes(music_sound_nodes, value_percentage, min_volume, max_volume)

func set_sound_effect_volume(value_percentage):
	var min_volume = -25
	var max_volume = 10
	var sound_effect_nodes = get_tree().get_nodes_in_group("SoundEffect")
	set_sound_to_nodes(sound_effect_nodes, value_percentage, min_volume, max_volume)

func set_menu_sound_volume(value_percentage):
	var min_volume = -15
	var max_volume = 20
	var menu_sound_nodes = get_tree().get_nodes_in_group("MenuSound")
	set_sound_to_nodes(menu_sound_nodes, value_percentage, min_volume, max_volume)

func set_sound_to_nodes(sound_nodes: Array[Node], value_percentage: float, min_volume: float, max_volume: float):
	var real_volume = (value_percentage/100.0)*(max_volume - min_volume) + min_volume
	for sound_node in sound_nodes:
		if real_volume <= min_volume:
			sound_node.volume_db = -100
		else:
			sound_node.volume_db = real_volume
