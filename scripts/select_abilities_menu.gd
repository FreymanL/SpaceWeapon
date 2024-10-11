extends Control

@onready var abilities_container = $PositionReference/Background/AbilitiesContainer
@onready var warning_label = $PositionReference/WarningLabel
@onready var slots_container = $PositionReference/Background/SlotsContainer
@onready var slot = load("res://scenes/menu_controls/ability_slot_button.tscn")
@onready var ability_btn = load("res://scenes/menu_controls/ability_button.tscn")
@onready var settings = load("res://scenes/settings.tscn").instantiate()
@onready var pressed_audio = $BtnPressedAudio
@onready var locked_audio = $BtnLockedAudio

var slot_selected : TextureButton
var current_abilities_selected = {}
var abilities_set = {}
var num_abilities = 3
var slots = {}
var world_info
var available_abilities = {}

signal abilities_selected(abilities)
signal abilities_selected_canceled
	
func load_parameters(level: String):
	current_abilities_selected.clear()
	for current_slot in slots:
		slots[current_slot].queue_free()
	for current_abilities in available_abilities:
		available_abilities[current_abilities].queue_free()
	world_info = settings.get_key("worlds")[level]
	num_abilities = world_info["num_abilities"]
	slots.clear()
	load_slots()
	load_abilities()

func load_slots():
	for i in num_abilities:	
		var slot_instance = slot.instantiate()
		slot_instance.num = i
		slots_container.add_child(slot_instance)
		slot_instance.connect("button_has_pressed", set_slot_selected)
		slots[i] = slot_instance
	abilities_set.clear()
	set_next_free_slot()
	

func load_abilities():
	UserData.load_data()
	var user_abilities: Dictionary = UserData.user_data.abilities
	for ability_id in user_abilities:
		var ability_instance = ability_btn.instantiate()
		abilities_container.add_child(ability_instance)
		ability_instance.set_ability(ability_id)
		ability_instance.connect("ability_selected", process_ability_selected)
		available_abilities[ability_id] = ability_instance

func set_slot_selected(num: int):
	slot_selected = slots[num]
	slot_selected.grab_focus()

func process_ability_selected(ability: TextureButton):
	if slot_selected == null:
		locked_audio.play()
		return
	if abilities_set.has(ability.ability_id):
		locked_audio.play()
		return
	slot_selected.texture_normal = ability.texture_normal
	current_abilities_selected[slot_selected.num] = ability.ability_id
	refresh_abilities_set()
	set_next_free_slot()
	pressed_audio.play()

func _on_go_pressed():
	if len(current_abilities_selected) != num_abilities:
		warning_label.text = "Select " + str(num_abilities) + " " + check_plural(num_abilities)
		locked_audio.play()
		return
	pressed_audio.play()
	emit_signal("abilities_selected", current_abilities_selected)
	
func check_plural(num):
	if num == 1:
		return "ability"
	return "abilities"
	
func _on_back_pressed():
	pressed_audio.play()
	emit_signal("abilities_selected_canceled")
	
func set_next_free_slot():
	for i in num_abilities:
		if !current_abilities_selected.has(i):
			set_slot_selected(i)
			return

func refresh_abilities_set():
	abilities_set.clear()
	for ability_selected in current_abilities_selected:
		abilities_set[current_abilities_selected[ability_selected]] = true

