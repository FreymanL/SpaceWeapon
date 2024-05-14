extends Area2D

@onready var sprite = $Sprite
@export var icon : CompressedTexture2D
@onready var hit = $HitAudio
@onready var interaction_manager = get_tree().get_first_node_in_group("InteractionManager")
@onready var booster_manager: Node2D = get_tree().get_first_node_in_group("BoosterManager")
@onready var execution_time = $ExecutionTime
signal reached_target(shoot: Area2D, target: Area2D)

var ship
var cooldown = 40
var duration = 10.0

var damage_stats = {
	"normal_health": 100
}
# Called when the node enters the scene tree for the first time.
func _ready():
	duration = booster_manager.calculate_skill_duration(duration)
	execution_time.start(duration)
	interaction_manager.connect_with(self)
	ship = get_tree().get_first_node_in_group("Ship")
	sprite.play("ready")
	ship.collision_shape.disabled = true
	

func _process(delta):
	if ship.is_destroying || ship.level_completed:
		queue_free()
	global_position = ship.global_position

func _on_execution_timer_timeout():
	ship.collision_shape.disabled = false
	emit_signal("reached_target", self, ship)
	queue_free()

	
func normal_damage_received(damage: float):
	damage_stats["normal_health"] += (damage * 0.1)
	light()
	return 0

func light():
	hit.play()
	sprite.modulate = "ffffff"
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = "ffffff76"

func get_real_name():
	return "Shield"
