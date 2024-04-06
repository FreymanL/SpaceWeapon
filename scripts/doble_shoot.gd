extends Node2D

@onready var left = $Left
@onready var right = $Right
@export var icon : CompressedTexture2D

var rng = RandomNumberGenerator.new()
var ship
var world
var shoot : PackedScene
var damage_boost = 0.1 #50% more damage per shoot
var speed_boost = 0.3 #30% more speed in each shoot
var duration = 10
var cooldown = 40

func _ready():
	ship = get_tree().get_first_node_in_group("Ship")
	world = get_tree().get_first_node_in_group("Mundo")
	world.connect("level_has_completed", queue_free)
	shoot = ship.shoot
	ship.shoot_is_disabled = true
	_on_shoot_timeout()


func _process(_delta):
	global_position = ship.global_position


func _on_shoot_timeout():
	shoot_side(left)
	shoot_side(right)

func shoot_side(node : Node2D):
	var shoot_instance = shoot.instantiate()
	shoot_instance.global_position = node.global_position
	shoot_instance.damage = shoot_instance.damage * (1 + damage_boost)
	shoot_instance.speed = 	shoot_instance.speed * (1 + speed_boost)
	shoot_instance.scale_setted = shoot_instance.scale_setted * Vector2(2,2)
	var number = rng.randi_range(0,1000)
	shoot_instance.name =  shoot_instance.name + str(number)
	world.add_child(shoot_instance)


func _on_execution_time_timeout():
	ship.shoot_is_disabled = false
	queue_free()
