extends Area2D

@onready var sprite = $Sprite
@onready var action_shape = $ActionArea
@onready var booster_manager = get_tree().get_first_node_in_group("BoosterManager")
@onready var interaction_manager = get_tree().get_first_node_in_group("InteractionManager")

var speed : int = 600
var is_crashing = false
var life_points_percentage_damage : int = 0
var target : Vector2
var dir : Vector2

signal reached_target(shoot: Area2D, target: Area2D)

const targets = {
	"Ship": true,
	"Shield": true,
	"AttackDrone": true,
	}

const damage_stats = {
	"normal_damage": 200,
}

func _ready():
	interaction_manager.connect_with(self)
	sprite.play("shoot")
	var world = get_tree().get_first_node_in_group("Mundo")
	world.connect("level_has_completed", queue_free)
	action_shape.disabled = true
	dir = global_position.direction_to(target)
	look_at(target)

func _process(delta):
	if is_crashing:
		return
	global_position += speed * delta * dir
	if !target || global_position.y > target.y:
		crashed()

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

func crashed():
	is_crashing = true
	active_area()
	modulate = Color("ffffff45")
	sprite.play("crashed")
	for i in 4:
		sprite.scale += Vector2(0.25,0.25)
		await get_tree().create_timer(0.05).timeout
	queue_free()

func active_area():
	action_shape.set_deferred("disabled",false)
	await get_tree().create_timer(0.2).timeout
	action_shape.set_deferred("disabled",true)

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
