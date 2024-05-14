extends Node2D

@onready var ship : Area2D = get_tree().get_first_node_in_group("Ship")
@onready var world = get_tree().get_first_node_in_group("Mundo")

var skills_tree = {}

var additional_laser_damage: float
var additional_general_damage_percentage: float
var additional_life_points: float
var additional_life_points_percentage: float
var damage_received_reduction: float
var damage_received_reduction_percentage: float
var drone_additional_damage_percentage: float
var additional_area_damage_percentage: float
var additional_attack_speed_percentage: float
var additional_life_points_percentage_damage: float
var additional_healing_percentage: float
var laser_life_steal: float
var additional_speed_percentage: float
var missing_life_regeneration_percentage: float
var ability_cooldown_reduction_percentage: float
var additional_ability_duration_percentage: float
var drone_additional_life_percentage: float
var drone_damage_reduced_percentage: float

func execute_boosters(skills_tree_):
	skills_tree = skills_tree_
	set_info()

func set_info():
	additional_laser_damage = skills_tree["laser_damage"]
	additional_general_damage_percentage = skills_tree["additional_general_damage_percentage"]
	additional_life_points = skills_tree["additional_life_points"]
	additional_life_points_percentage = skills_tree["additional_life_points_percentage"]
	damage_received_reduction_percentage = skills_tree["damage_received_reduction_percentage"]
	damage_received_reduction = skills_tree["damage_received_reduction"]
	drone_additional_damage_percentage = skills_tree["drone_additional_damage_percentage"]
	additional_area_damage_percentage = skills_tree["additional_area_damage_percentage"]
	additional_attack_speed_percentage = skills_tree["additional_attack_speed_percentage"]
	additional_life_points_percentage_damage = skills_tree["additional_life_points_percentage_damage"]
	additional_healing_percentage = skills_tree["additional_healing_percentage"]
	laser_life_steal = skills_tree["laser_life_steal"]
	additional_speed_percentage = skills_tree["additional_speed_percentage"]
	missing_life_regeneration_percentage = skills_tree["missing_life_regeneration_percentage"]
	ability_cooldown_reduction_percentage = skills_tree["ability_cooldown_reduction_percentage"]
	additional_ability_duration_percentage = skills_tree["additional_ability_duration_percentage"]
	drone_additional_life_percentage = skills_tree["drone_additional_life_percentage"]
	drone_damage_reduced_percentage = skills_tree["drone_damage_reduced_percentage"]

func set_laser_damage(laser):
	var stats = laser.damage_stats
	if stats.has("normal_damage"):
		var normal_damage = stats["normal_damage"]
		normal_damage = (normal_damage + additional_laser_damage)*additional_general_damage_percentage
		stats["normal_damage"] = normal_damage
	var total_additional_life_points_percentage_damage = additional_life_points_percentage_damage*additional_general_damage_percentage
	if stats.has("additional_life_points_percentage_damage"):
		stats["additional_life_points_percentage_damage"] += total_additional_life_points_percentage_damage
	else:
		stats["additional_life_points_percentage_damage"] = total_additional_life_points_percentage_damage


func calculate_ship_speed(speed: float):
	return ceil(speed * additional_speed_percentage)

func calculate_damage_received(damage: float):
	var real_damage: float = floor(max(damage - damage_received_reduction,0)*damage_received_reduction_percentage)
	return real_damage
	
func calculate_drone_damage(damage: float):
	var real_damage: float = round(damage*additional_general_damage_percentage*drone_additional_damage_percentage)
	return real_damage
	
func calculate_drone_life_points(life_points: float):
	return round(life_points * drone_additional_life_percentage)

func calculate_drone_damage_received(damage: float):
	return round(damage*drone_damage_reduced_percentage)

func calculate_ship_life_points(life_points):
	var max_life_points : float = round((life_points + additional_life_points)*additional_life_points_percentage)
	return max_life_points

func calculate_ship_laser_damage(damage):
	var real_damage: float = round((ship.LASER_DAMAGE + additional_laser_damage)*additional_general_damage_percentage)
	return real_damage
	
func calculate_area_damage(damage):
	var real_damage: float = round(damage * additional_general_damage_percentage * additional_area_damage_percentage)
	return real_damage

func calculate_ship_attack_speed(speed):
	var real_speed : float = speed * additional_attack_speed_percentage
	return real_speed

func calculate_ship_life_percentage_damage(life_damage_percentage):
	var real_damage_percentage : float  = life_damage_percentage + additional_life_points_percentage_damage
	return real_damage_percentage

func calculate_ship_health(health: float):
	return round(health*additional_healing_percentage)

func calculate_skill_cooldown(cooldown: float):
	return round(cooldown*ability_cooldown_reduction_percentage)

func calculate_skill_duration(duration: float):
	return duration*additional_ability_duration_percentage
	

