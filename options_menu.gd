extends Node2D

@onready var music_slider = $Background/VBoxContainer/MusicSlider
@onready var sound_effect_slider = $Background/VBoxContainer/SoundEffectSlider
@onready var menu_sound_slider = $Background/VBoxContainer/MenuSoundSlider
@onready var pressed_audio = $BtnPressedAudio

signal ok_options

func _ready():
	UserData.load_data()
	music_slider.value = UserData.user_data.music_volume
	sound_effect_slider.value = UserData.user_data.sound_effect_volume
	menu_sound_slider.value = UserData.user_data.menu_effect_volume

func _on_music_slider_value_changed(value):
	UserData.user_data.music_volume = value
	UserData.save_data()

func _on_sound_effect_slider_value_changed(value):
	UserData.user_data.sound_effect_volume = value
	UserData.save_data()

func _on_menu_sound_slider_value_changed(value):
	UserData.user_data.menu_effect_volume = value
	UserData.save_data()

func _on_ok_pressed():
	pressed_audio.play()
	emit_signal("ok_options")
