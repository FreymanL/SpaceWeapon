extends Area2D

@onready var sprite = $Sprite
@onready var audio = $Audio
@export var icon : CompressedTexture2D
@onready var collision_shape = $CollisionShape2D
@onready var booster_manager: Node2D = get_tree().get_first_node_in_group("BoosterManager")
@onready var interaction_manager = get_tree().get_first_node_in_group("InteractionManager")
@onready var execution_time = $ExecutionTime

var targets = {}

var damage_stats = {
	"normal_damage": 60
}

signal reached_target(shoot: Area2D, target: Area2D)

var duration = 10
var is_active = false
var ship
var cooldown = 20
var reset = false
var boost_speed = 1.5

func _ready():
	duration = booster_manager.calculate_skill_duration(duration)
	execution_time.start(duration)
	interaction_manager.connect_with(self)
	sprite.play("default")
	ship.speed *= boost_speed
	targets = Settings.get_key("enemies")
	execute()

func _process(_delta):
	if ship.is_destroying || ship.level_completed:
		queue_free()
	global_position = ship.global_position

func execute():
	audio.play()
	damage_stats["normal_damage"] = booster_manager.calculate_area_damage(damage_stats["normal_damage"])
	is_active = true
	ship.shoot_is_disabled -= 1
	await get_tree().create_timer(0.2).timeout

func _on_timer_timeout():
	if !reset:
		remove_child(collision_shape)
	else:
		add_child(collision_shape)
	reset = !reset


func _on_area_entered(area):
	var object_name: String
	if area.has_method("get_real_name"):
		object_name = area.get_real_name()
	else:
		object_name = area.get_name()
	if targets.has(object_name):
		emit_signal("reached_target",self, area)


func _on_execution_time_timeout():
	is_active = false
	ship.shoot_is_disabled += 1
	ship.speed *= (1 / boost_speed)
	queue_free()
