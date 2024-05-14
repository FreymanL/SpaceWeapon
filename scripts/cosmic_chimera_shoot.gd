extends Area2D

var speed : int = 450
var is_crashing = false
var life_points_percentage_damage : int = 0
var ship
var dir : Vector2
@onready var sprite = $Sprite
@onready var booster_manager = get_tree().get_first_node_in_group("BoosterManager")
@onready var interaction_manager = get_tree().get_first_node_in_group("InteractionManager")

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
	world.connect("level_has_completed", destroy)
	ship = get_tree().get_first_node_in_group("Ship")
	set_direction()
		
func destroy():
	queue_free()

func set_direction():
	dir = global_position.direction_to(ship.global_position)
	look_at(ship.global_position)

func _process(delta):
	if is_crashing:
		return
	global_position += dir * speed * delta


func _on_visible_on_screen_enabler_2d_screen_exited():
	destroy()

func crashed():
	is_crashing = true
	PROCESS_MODE_DISABLED
	scale = Vector2(0.25, 0.25)
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
	return "CosmicChimeraShoot"
