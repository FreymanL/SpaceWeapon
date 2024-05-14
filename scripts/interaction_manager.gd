extends Node2D

var level_completed = false

@onready var delta = load("res://scenes/in_game_items/delta.tscn")
@onready var world = get_tree().get_first_node_in_group("Mundo").connect("level_has_completed", set_level_completed)

signal damage_has_been_done(source: Area2D, target: Area2D, damage: float)

var health_process_factory: Dictionary = {
	"normal_health": "calculate_normal_health",
}

var damage_process_factory: Dictionary = {
	"normal_damage": "calculate_normal_damage",
	"additional_life_points_percentage_damage": "calculate_additional_life_points_percentage_damage",
}

func connect_with(agent: Node2D):
	agent.connect("reached_target", process_interaction_event)
	

func process_interaction_event(source: Node2D, target: Area2D):
	if level_completed:
		return
	
	var total_damage: float = 0.0
	var total_health: float = 0.0
	
	var stats = source.damage_stats
	for stat_type in stats:
		if damage_process_factory.has(stat_type):
			total_damage += call(damage_process_factory[stat_type], stats[stat_type],source, target)
		if health_process_factory.has(stat_type):
			total_health += call(health_process_factory[stat_type], stats[stat_type],source, target)
			
	process_normal_damage(total_damage, source, target)
	process_normal_health(total_health, source, target)

func process_normal_damage(damage: float, source: Node2D ,target: Node2D):
	if damage == 0:
		return
	var real_damage = target.normal_damage_received(damage)
	emit_signal("damage_has_been_done",source, target, real_damage)
	show_damage(real_damage, target)

func process_normal_health(health: float, source: Node2D, target: Node2D):
	if health == 0:
		return
	var real_health = target.normal_health_received(health)
	if real_health == 0:
		return
	show_health(real_health, target)

	

func calculate_additional_life_points_percentage_damage(percentage: float, source: Node2D, target: Node2D):
	var life_points: float = target.max_life_points
	var real_damage: float = life_points*percentage
	return real_damage

func calculate_normal_damage(damage: float, source: Node2D, target: Node2D):
	return damage
	
func calculate_normal_health(health: float, source: Node2D, target: Node2D):
	return health

func set_level_completed():
	level_completed = true

func show_damage(damage, target):
	var delta_instance = delta.instantiate()
	delta_instance.global_position = target.global_position
	get_tree().call_group("Mundo", "add_child", delta_instance)
	delta_instance.show_damage(damage)
	
func show_health(health, target):
	var delta_instance = delta.instantiate()
	delta_instance.global_position = target.global_position
	get_tree().call_group("Mundo", "add_child", delta_instance)
	delta_instance.show_health(health)
	
