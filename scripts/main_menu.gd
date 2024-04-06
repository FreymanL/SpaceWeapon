extends Control

@onready var btn_play = $ButtonContainer
@onready var btn_conainter = $ButtonContainer/Play
@onready var level_menu = $LevelMenu
@onready var title_label = $TitleLabel
@onready var abilities_menu = $SelectAbilitiesMenu

var level_selected

signal play_world(parameters : Dictionary)

func _ready():
	btn_play.grab_focus()
	level_menu.connect("level_selected", set_level_selected)
	level_menu.connect("level_selected_canceled", process_level_selected_canceled)
	abilities_menu.connect("abilities_selected", set_abilities_selected)
	abilities_menu.connect("abilities_selected_canceled", process_abilities_selected_canceled)

func set_abilities_selected(abilities):
	var parameters = {
		"world": level_selected,
		"abilities": abilities
	}
	emit_signal("play_world", parameters)
	
func set_level_selected(level):
	level_selected = level
	level_menu.hide()
	abilities_menu.show()
	abilities_menu.load_parameters(level)

func process_level_selected_canceled():
	level_menu.hide()
	show_main_menu()

func process_abilities_selected_canceled():
	level_menu.show()
	abilities_menu.hide()

func _on_play_pressed():
	hide_main_menu()
	level_menu.show()

func _on_back_pressed():
	level_menu.show()
	show_main_menu()

func hide_main_menu():
	btn_conainter.visible = false
	title_label.visible = false
	
func show_main_menu():
	btn_conainter.visible = true
	title_label.visible = true

