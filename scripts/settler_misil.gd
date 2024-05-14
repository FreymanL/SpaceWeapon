extends Area2D

@onready var sprite = $Sprite
@onready var action_shape = $ActionArea
@onready var booster_manager = get_tree().get_first_node_in_group("BoosterManager")
@onready var interaction_manager = get_tree().get_first_node_in_group("InteractionManager")

var speed : int = 600
var is_crashing = false
var life_points_percentage_damage : int = 0
var ship
var dir : Vector2
var target: Vector2

signal reached_target(shoot: Area2D, target: Area2D)

const targets = {
	"Ship": true,
	"Shield": true,
	"AttackDrone": true,
	}

const damage_stats = {
	"normal_damage": 300,
}

func _ready():
	interaction_manager.connect_with(self)
	sprite.play("shoot")
	var world = get_tree().get_first_node_in_group("Mundo")
	world.connect("level_has_completed", queue_free)
	ship = get_tree().get_first_node_in_group("Ship")
	look_at(target)
	dir = global_position.direction_to(target)
	action_shape.disabled = true

func _process(delta):
	if is_crashing:
		return
	global_position += dir * speed * delta
	if global_position.distance_to(target) <= 10:
		crashed()

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

func crashed():
	is_crashing = true
	active_area()
	sprite.scale = Vector2(0.5,0.5)
	sprite.play("crashed")
	await get_tree().create_timer(0.5).timeout
	queue_free()

func active_area():
	action_shape.disabled = false
	await get_tree().create_timer(0.2).timeout
	action_shape.disabled = true

func _on_area_entered(area):
	var object_name: String
	if area.has_method("get_real_name"):
		object_name = area.get_real_name()
	else:
		object_name = area.get_name()
	if targets.has(object_name):
		emit_signal("reached_target",self, area)
		crashed()

func get_real_name():
	return "SettlerShoot"
