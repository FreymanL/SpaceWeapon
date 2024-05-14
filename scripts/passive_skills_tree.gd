extends Control

@onready var ability_points_lbl = $Background/SubTitleContainer
@onready var warning_label = $WarningLabel
@onready var path = $Path
var num_ability_points = 12
var current_ability_points : int
var passive_skills = {}

signal ability_tree_select_canceled()
signal tree_has_reestarted()

var summary_skills = {
	"laser_damage": 0.0,
	"additional_general_damage_percentage": 1.0,
	"damage_received_reduction": 0.0,
	"additional_area_damage_percentage": 1.0,
	"additional_attack_speed_percentage": 1.0,
	"additional_life_points_percentage_damage": 0.0,
	"laser_life_steal": 0.0,
	"debuff_duration": 1.0,
	"damage_received_reduction_percentage": 1.0,
	"additional_speed_percentage": 1.0,
	"additional_life_points": 0.0,
	"additional_healing_percentage": 1.0,
	"missing_life_regeneration_percentage": 0.0,
	"additional_life_points_percentage": 1.0,
	"ability_cooldown_reduction_percentage": 1.0,
	"drone_additional_life_percentage": 1.0,
	"drone_additional_damage_percentage": 1.0,
	"drone_damage_reduced_percentage": 1.0,
	"additional_ability_duration_percentage": 1.0,
}

var skill_is_percentage = {
	"laser_damage": false,
	"additional_general_damage_percentage": true,
	"base_life_points": false,
	"damage_received_reduction": false,
	"additional_area_damage_percentage": true,
	"additional_attack_speed_percentage": true,
	"additional_life_points_percentage_damage": false,
	"laser_life_steal": false,
	"debuff_duration": true,
	"damage_received_reduction_percentage": true,
	"additional_speed_percentage": true,
	"additional_life_points": false,
	"additional_healing_percentage": true,
	"missing_life_regeneration_percentage": false,
	"additional_life_points_percentage": true,
	"ability_cooldown_reduction_percentage": true,
	"drone_additional_life_percentage": true,
	"drone_additional_damage_percentage": true,
	"drone_damage_reduced_percentage": true,
	"additional_ability_duration_percentage": true,
}

signal tree_has_setted(summary_statistics : Dictionary)
signal skill_has_upgraded(skill_id: String, current_level: int)

func _ready():
	get_tree().get_first_node_in_group("UpgradesMenu").connect("item_bought", update_points)
	num_ability_points = UserData.user_data.ability_points
	current_ability_points = num_ability_points
	update_ability_points_lbl()
	passive_skills = get_tree().get_nodes_in_group("PassiveSkillNode")
	for passive_node in passive_skills:
		passive_node.connect("try_upgrade_skill", process_try_upgrade_skill)
	path.set_paths()

func update_points(item: Control):
	if item.item_id != "ability_point":
		return
	UserData.load_data()
	num_ability_points = UserData.user_data.ability_points
	emit_signal("tree_has_reestarted")
	current_ability_points = num_ability_points
	update_ability_points_lbl()

func process_try_upgrade_skill(skill_id: String, current_level: int):
	if current_ability_points == 0:
		warning_label.text = "you have no skill points left"
		return
	current_ability_points -= 1;
	update_ability_points_lbl()
	emit_signal("skill_has_upgraded", skill_id, current_level + 1)

func update_ability_points_lbl():
	ability_points_lbl.text = "Ability Points: " + str(current_ability_points)

func _on_save_pressed():
	if current_ability_points > 0:
		warning_label.text = "you have pending points to be assigned"
		return
	var skill_nodes = get_tree().get_nodes_in_group("PassiveSkillNode")
	for node in skill_nodes:
		node.save_statistics()
	emit_signal("tree_has_setted", summary_skills)

func _on_back_pressed():
	emit_signal("ability_tree_select_canceled")

func _on_texture_button_pressed():
	emit_signal("tree_has_reestarted")
	current_ability_points = num_ability_points
	update_ability_points_lbl()
