extends Control

@onready var abilities_container = $PositionReference/Background/AbilitiesContainer
@onready var super_shoot_btn = $PositionReference/Background/AbilitiesContainer/SuperShootButton
@onready var shield_btn = $PositionReference/Background/AbilitiesContainer/ShieldButton
@onready var double_shoot_btn = $PositionReference/Background/AbilitiesContainer/DoubleShootButton
@onready var warning_label = $PositionReference/WarningLabel
@onready var attack_drone_btn = $PositionReference/Background/AbilitiesContainer/AttackDroneButton
@onready var energy_burst_btn = $PositionReference/Background/AbilitiesContainer/EnergyBurstButton
@onready var slots_container = $PositionReference/Background/SlotsContainer
@onready var slot = load("res://scenes/menu_controls/ability_slot_button.tscn")
@onready var ability_btn = load("res://scenes/menu_controls/ability_button.tscn")
@onready var settings = load("res://scenes/settings.tscn").instantiate()
var slot_selected : TextureButton
var abilities = {}
var num_abilities = 3
var slots = {}
var world_info
var available_abilities = {}

signal abilities_selected(abilities)
signal abilities_selected_canceled

func _ready():
	pass

func load_slots():
	for i in num_abilities:	
		var slot_instance = slot.instantiate()
		slot_instance.num = i
		slots_container.add_child(slot_instance)
		slot_instance.connect("button_has_pressed", set_slot_selected)
		slots[i] = slot_instance

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
	
func load_parameters(level: String):
	for slot in slots:
		slots[slot].queue_free()
	for abilities in available_abilities:
		available_abilities[abilities].queue_free()
	world_info = settings.get_key("worlds")[level]
	num_abilities = world_info["num_abilities"]
	load_slots()
	load_abilities()
		

func process_ability_selected(ability: TextureButton):
	if slot_selected == null:
		return
	slot_selected.texture_normal = ability.texture_normal
	abilities[slot_selected.num] = ability.ability_id

func _on_go_pressed():
	var abilities_selected = len(abilities)
	if abilities_selected != num_abilities:
		warning_label.text = "Select " + str(num_abilities) + " " + check_plural(num_abilities)
		return
	emit_signal("abilities_selected", abilities)
	
func check_plural(num_abilities):
	if num_abilities == 1:
		return "ability"
	return "abilities"
	
func _on_back_pressed():
	emit_signal("abilities_selected_canceled")


