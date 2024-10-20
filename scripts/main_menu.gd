extends Control

@onready var btn_play = $ButtonContainer/Play
@onready var btn_containter = $ButtonContainer
@onready var level_menu = $LevelMenu
@onready var title_label = $TitleLabel
@onready var abilities_menu = $SelectAbilitiesMenu
@onready var skills_tree = $PassiveSkillsTree
@onready var upgrades_menu = $UpgradesMenu
@onready var pressed_audio = $BtnPressedAudio
@onready var options_menu = $OptionsMenu

var level_selected

signal play_world(parameters : Dictionary)

var parameters = {}

func _ready():
	level_menu.connect("level_selected", set_level_selected)
	level_menu.connect("level_selected_canceled", process_level_selected_canceled)
	abilities_menu.connect("abilities_selected", set_abilities_selected)
	abilities_menu.connect("abilities_selected_canceled", process_abilities_selected_canceled)
	skills_tree.connect("tree_has_setted", process_tree_has_setted)
	skills_tree.connect("ability_tree_select_canceled", process_skill_tree_canceled)
	upgrades_menu.connect("back_home", process_upgrades_back_home)
	options_menu.connect("ok_options", process_ok_options)
	btn_play.grab_focus()

func set_level_selected(level):
	level_selected = level
	parameters["world"] = level_selected
	level_menu.hide()
	abilities_menu.show()
	abilities_menu.load_parameters(level)
	
func process_level_selected_canceled():
	level_menu.hide()
	show_main_menu()

func process_upgrades_back_home():
	upgrades_menu.hide()
	show_main_menu()


func set_abilities_selected(abilities):
	parameters["abilities"] = abilities
	abilities_menu.hide()
	skills_tree.show()
	skills_tree.restart()
	

func process_abilities_selected_canceled():
	level_menu.show()
	abilities_menu.hide()
	
func process_tree_has_setted(sumary_skill : Dictionary):
	parameters["skills_tree"] = sumary_skill
	emit_signal("play_world", parameters)
	
func process_skill_tree_canceled():
	skills_tree.hide()
	abilities_menu.show()

func _on_play_pressed():
	pressed_audio.play()
	hide_main_menu()
	level_menu.show()
	level_menu.load_worlds()

func hide_main_menu():
	btn_containter.visible = false
	title_label.visible = false
	
func show_main_menu():
	btn_containter.visible = true
	title_label.visible = true
	btn_play.grab_focus()

func _on_upgrades_pressed():
	pressed_audio.play()
	hide_main_menu()
	upgrades_menu.show()
	
func process_ok_options():
	options_menu.hide()
	show_main_menu()


func _on_options_pressed():
	pressed_audio.play()
	hide_main_menu()
	options_menu.show()
