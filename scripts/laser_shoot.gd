extends Area2D

var speed = 1500
var life_points_percentage_damage : int = 0
var is_crashing = false
var scale_setted = Vector2(2.3,2.3)

@onready var sprite = $Sprite
@onready var shoot_audio = $ShootAudio
@onready var collision_shape = $CollisionShape
@onready var booster_manager = get_tree().get_first_node_in_group("BoosterManager")
@onready var interaction_manager = get_tree().get_first_node_in_group("InteractionManager")


signal reached_target(shoot: Area2D, target: Area2D)

var targets = {}

var damage_stats = {
	"normal_damage": 100.0,
}

func _ready():
	interaction_manager.connect_with(self)
	sprite.play("default")
	shoot_audio.play()
	scale = scale_setted
	var world = get_tree().get_first_node_in_group("Mundo")
	world.connect("level_has_completed", queue_free)
	booster_manager.set_laser_damage(self)
	targets = Settings.get_key("enemies")


func _process(delta):
	if is_crashing == false:
		global_position.y -= speed * delta

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

func crashed():
	is_crashing = true
	collision_shape.queue_free()
	scale.x = 0.1
	scale.y = 0.1
	sprite.play("crashed")
	await get_tree().create_timer(0.1).timeout
	queue_free()

func _on_area_entered(area):
	var object_name: String
	if area.has_method("get_real_name"):
		object_name = area.get_real_name()
	else:
		object_name = area.get_name()
	if targets.has(object_name):
		emit_signal("reached_target",self, area)
		crashed()
		
func buff(boost: float):
	damage_stats["normal_damage"] *= boost

func get_real_name():
	return "LaserShoot"
