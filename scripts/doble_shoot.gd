extends Node2D

@onready var left = $Left
@onready var right = $Right
@onready var shoot_timer = $Shoot
@export var icon : CompressedTexture2D
@onready var execution_time = $ExecutionTime
var rng = RandomNumberGenerator.new()
var ship
var world
var shoot : PackedScene
var damage_boost = 1.1 #50% more damage per shoot
var speed_boost = 1.3 #30% more speed in each shoot
var duration = 10
var cooldown = 40
@onready var booster_manager: Node2D = get_tree().get_first_node_in_group("BoosterManager")
@onready var interaction_manager: Node2D = get_tree().get_first_node_in_group("InteractionManager")

func _ready():
	duration = booster_manager.calculate_skill_duration(duration)
	execution_time.start(duration)
	shoot_timer.wait_time = booster_manager.calculate_ship_attack_speed(shoot_timer.wait_time)
	ship = get_tree().get_first_node_in_group("Ship")
	world = get_tree().get_first_node_in_group("Mundo")
	world.connect("level_has_completed", queue_free)
	shoot = ship.shoot
	ship.shoot_is_disabled -= 1
	_on_shoot_timeout()


func _process(_delta):
	if ship.is_destroying:
		queue_free()
	global_position = ship.global_position


func _on_shoot_timeout():
	shoot_side(left)
	shoot_side(right)

func shoot_side(node : Node2D):
	var shoot_instance = shoot.instantiate()
	shoot_instance.global_position = node.global_position
	shoot_instance.buff(damage_boost)
	shoot_instance.speed = 	shoot_instance.speed * speed_boost
	shoot_instance.scale_setted = shoot_instance.scale_setted * Vector2(2,2)
	var number = rng.randi_range(0,1000)
	shoot_instance.name =  shoot_instance.name + str(number)
	world.add_child(shoot_instance)



func _on_execution_time_timeout():
	ship.shoot_is_disabled += 1
	queue_free()
