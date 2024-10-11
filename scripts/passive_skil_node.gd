extends TextureButton

@export var skill_id : String

@onready var game_settings = load("res://scenes/settings.tscn").instantiate()
@onready var level_lbl = $Level
@onready var title = $Title
@onready var path_vertice = $PathVertice
var description_dialog

var skill_info = {}
var skill_name : String
var current_description : String
var num_levels : int
var stats_description = {}
var current_level : int
var prenode_id : String
var locked = false
var tree
var current_stats = {}
var prenode
var prenode_minimun_level = 2
var path_to : Line2D
var skill_locked = false

signal try_upgrade_skill(id: String, current_level: int)

func _ready():
	description_dialog = get_tree().get_first_node_in_group("NodeDescriptionDialog")
	tree = get_tree().get_first_node_in_group("PassiveSkillsTree")
	tree.connect("skill_has_upgraded", process_skill_has_upgraded)
	tree.connect("tree_has_reestarted", process_tree_has_reestarted)
	current_level = 0
	skill_info = game_settings.get_key("ability_tree")[skill_id]
	skill_name = skill_info["name"]
	var skill_icon = skill_info["icon_name"]
	num_levels = skill_info["levels"]
	current_description = skill_info["description_per_level"][min(current_level+1, num_levels)]["description"]
	texture_normal = load("res://images/ability_tree/789_Lorc_RPG_icons/"+skill_icon)
	prenode = skill_info["prenode"]
	title.text = skill_name
	set_current_level()
	set_lock_skill()
		

func set_lock_skill():
	if skill_id == "base":
		return
	modulate = "ffffff5d"
	skill_locked = true
	disabled = true


func set_unlock_skill():
	modulate = "ffffff"
	skill_locked = false
	disabled = false

func process_tree_has_reestarted():
	current_level = 0
	set_current_level()
	set_lock_skill()
	current_stats = {}

func process_skill_has_upgraded(skill_id_: String, level: int):
	if skill_id_ == skill_id:
		current_level = level
		if path_to != null:
			path_to.active_path()
		set_current_level()
	if skill_id_ == prenode && level == prenode_minimun_level:
		set_unlock_skill()

func _on_pressed():
	if current_level == num_levels:
		print("this ability is already maximized")
		return
	emit_signal("try_upgrade_skill", skill_id, current_level)
	await get_tree().create_timer(0.2).timeout
	_on_mouse_entered()

func set_current_level():
	if current_level != 0:
		var statistics = skill_info["stats_per_level"][current_level]
		for statistic in statistics:
			current_stats[statistic] = statistics[statistic]
	level_lbl.text = str(current_level) + "/" + str(num_levels)
	current_description = skill_info["description_per_level"][min(current_level+1, num_levels)]["description"]

func save_statistics():
	for key in current_stats:
		if tree.skill_is_percentage[key]:
			tree.summary_skills[key] *= current_stats[key]
		else:
			tree.summary_skills[key] += current_stats[key]

func _on_mouse_entered():
	description_dialog.show_text(current_description)

func get_vertice():
	return path_vertice.global_position 
