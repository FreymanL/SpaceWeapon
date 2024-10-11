extends Area2D

var speed : int = 500
var is_crashing = false
var life_points_percentage_damage : int = 0

@onready var sprite = $Sprite

signal reached_target(shoot: Area2D, target: Area2D)
@onready var interaction_manager = get_tree().get_first_node_in_group("InteractionManager")

const targets = {
	"Ship": true,
	"Shield": true,
	"AttackDrone": true,
	}

const damage_stats = {
	"normal_damage": 150,
}

func _ready():
	interaction_manager.connect_with(self)
	sprite.play("default")
	var mundo_group = get_tree().get_nodes_in_group("Mundo")
	for node in mundo_group:
		node.connect("level_has_completed", destroy)

func destroy():
	queue_free()

func _process(delta):
	if is_crashing:
		return
	global_position.y += speed * delta

func _on_visible_on_screen_enabler_2d_screen_exited():
	destroy()

func crashed():
	is_crashing = true
	sprite.play("crashed")
	await get_tree().create_timer(0.6).timeout
	destroy()


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
	return "AstropajoShoot"
