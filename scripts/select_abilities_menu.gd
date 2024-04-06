extends Control

@onready var ability_1_btn = $PositionReference/Background/SlotsContainer/Ability1
@onready var ability_2_btn = $PositionReference/Background/SlotsContainer/Ability2
@onready var super_shoot_btn = $PositionReference/Background/AbilitiesContainer/SuperShootButton
@onready var shield_btn = $PositionReference/Background/AbilitiesContainer/ShieldButton
@onready var double_shoot_btn = $PositionReference/Background/AbilitiesContainer/DoubleShootButton
@onready var warning_label = $PositionReference/WarningLabel
@onready var attack_drone_btn = $PositionReference/Background/AbilitiesContainer/AttackDroneButton
@onready var energy_burst_btn = $PositionReference/Background/AbilitiesContainer/EnergyBurstButton
@onready var slots_container = $PositionReference/Background/SlotsContainer
@onready var slot = load("res://scenes/ability_slot_button.tscn")
@onready var settings = load("res://scenes/settings.tscn").instantiate()
var slot_selected : TextureButton
var abilities = {}
var num_abilities = 3
var slots = {}
var world_info

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

func _process(delta):
	pass

func set_slot_selected(num: int):
	slot_selected = slots[num]
	
func load_parameters(level: String):
	for slot in slots:
		slots[slot].queue_free()
	world_info = settings.get_key(level)
	num_abilities = world_info["num_abilities"]
	load_slots()

func set_ability(ability_name : String, icon):
	if slot_selected == null:
		return
	slot_selected.texture_normal = icon
	abilities[slot_selected.num] = ability_name

func emit_abilities_selected():
	emit_signal("abilities_selected", abilities)

func _on_go_pressed():
	var abilities_selected = len(abilities)
	if abilities_selected != num_abilities:
		warning_label.text = "Select " + str(num_abilities) + " " + check_plural(num_abilities)
		return
	emit_abilities_selected()
	
func check_plural(num_abilities):
	if num_abilities == 1:
		return "ability"
	return "abilities"
	
func _on_back_pressed():
	emit_signal("abilities_selected_canceled")

func _on_super_shoot_button_pressed():
	set_ability("super_shoot", super_shoot_btn.texture_normal)

func _on_shield_button_pressed():
	set_ability("shield", shield_btn.texture_normal)

func _on_double_shoot_button_pressed():
	set_ability("doble_shoot", double_shoot_btn.texture_normal)


func _on_attack_drone_button_pressed():
	set_ability("attack_drone", attack_drone_btn.texture_normal)


func _on_energy_burst_button_pressed():
	set_ability("energy_burst", energy_burst_btn.texture_normal)

