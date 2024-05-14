extends Area2D

var speed = 1000
var life_points_percentage_damage : int = 0
var scale_setted = Vector2(0.5,0.5)
var current_target
var world_group
var dir
@onready var sprite = $Sprite
@onready var collision_shape = $CollisionShape
@onready var booster_manager: Node2D = get_tree().get_first_node_in_group("BoosterManager")
@onready var interaction_manager: Node2D = get_tree().get_first_node_in_group("InteractionManager")
signal reached_target(shoot: Area2D, target: Area2D)

var targets = {
	"astropajo": true,
	"cosmic_chimera": true,
	"settler": true,
}

var damage_stats = {
	"normal_damage": 100
}

func _ready():
	damage_stats["normal_damage"] = booster_manager.calculate_drone_damage(damage_stats["normal_damage"])
	interaction_manager.connect_with(self)
	sprite.play("default")
	scale = scale_setted
	world_group = get_tree().get_first_node_in_group("Mundo")
	world_group.connect("level_has_completed", queue_free)

func _process(delta):
	if current_target != null:
		dir = global_position.direction_to(current_target.global_position)
	if dir != null:
		global_position += dir * speed * delta
	else:
		queue_free()

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area == current_target:
		emit_signal("reached_target", self, area)
		queue_free()
		
func get_real_name():
	return "AttackDroneShoot"
