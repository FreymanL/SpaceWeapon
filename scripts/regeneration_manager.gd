extends Node2D

@onready var booster_manager: Node2D = get_tree().get_first_node_in_group("BoosterManager")
@onready var interaction_manager: Node2D = get_tree().get_first_node_in_group("InteractionManager")
@onready var ship: Node2D = get_tree().get_first_node_in_group("Ship")

signal reached_target(shoot: Node2D, target: Node2D)

var damage_stats = {
	"normal_health": 0.0,
}

func _ready():
	interaction_manager.connect_with(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	var regeneration_percentage = booster_manager.missing_life_regeneration_percentage
	if regeneration_percentage == 0:
		return
	var missing_life_percentage = ship.max_life_points - ship.life_points
	var total_regeneration = missing_life_percentage*regeneration_percentage
	damage_stats["normal_health"] = total_regeneration
	emit_signal("reached_target", self, ship)
