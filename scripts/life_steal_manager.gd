extends Node2D

@onready var interaction_manager : Node2D = get_tree().get_first_node_in_group("InteractionManager")
@onready var booster_manager : Node2D = get_tree().get_first_node_in_group("BoosterManager")
@onready var ship : Area2D = get_tree().get_first_node_in_group("Ship")
# Called when the node enters the scene tree for the first time.

var laser_name: String
var laser_life_steal: float
signal reached_target(shoot: Area2D, target: Area2D)

var damage_stats = {
	"normal_health": 0.0
}

func _ready():
	interaction_manager.connect_with(self)
	interaction_manager.connect("damage_has_been_done", process_damage_has_been_done)
	laser_name = ship.shoot.instantiate().get_real_name()
	
func process_damage_has_been_done(source: Area2D, target: Area2D, damage: float):
	if !source.has_method("get_real_name") || source.get_real_name() != laser_name:
		return
	interaction_manager.connect_with(self)
	laser_life_steal = booster_manager.laser_life_steal
	damage_stats["normal_health"] = damage * laser_life_steal
	emit_signal("reached_target", self, ship)

func _process(delta):
	pass

func get_real_name():
	return "LifeStealManager"

