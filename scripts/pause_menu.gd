extends Control

@onready var home_button = $Background/ButtonContainer/Home
@onready var resume_button = $Background/ButtonContainer/Resume
@onready var music_slider = $Background/VBoxContainer/MusicSlider
@onready var sound_effect_slider = $Background/VBoxContainer/SoundEffectSlider
@onready var menu_sound_slider = $Background/VBoxContainer/MenuSoundSlider
@onready var pressed_audio = $BtnPressedAudio
@onready var locked_audio = $BtnLockedAudio

func _ready():
	resume_button.grab_focus()
	UserData.load_data()
	music_slider.value = UserData.user_data.music_volume
	sound_effect_slider.value = UserData.user_data.sound_effect_volume
	menu_sound_slider.value = UserData.user_data.menu_effect_volume

func _on_resume_pressed():
	pressed_audio.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().paused = false
	queue_free()

func _on_home_pressed():
	pressed_audio.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().paused = false
	var scene_manager = get_tree().get_first_node_in_group("SceneManager")
	scene_manager.process_go_home()
	queue_free()

func _on_music_slider_value_changed(value):
	UserData.user_data.music_volume = value
	UserData.save_data()

func _on_sound_effect_slider_value_changed(value):
	UserData.user_data.sound_effect_volume = value
	UserData.save_data()

func _on_menu_sound_slider_value_changed(value):
	UserData.user_data.menu_effect_volume = value
	UserData.save_data()


