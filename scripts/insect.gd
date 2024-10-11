extends Area2D

@onready var sprite = $Sprite
@onready var ship = get_tree().get_first_node_in_group("Ship")
@onready var life_bar = $LifePointsBar
@onready var destroy_audio = $DestroyedAudio
@onready var action_shape = $ActionShape
@onready var interaction_manager: Node2D = get_tree().get_first_node_in_group("InteractionManager")
@onready var fore_front: Area2D
@onready var insect_shoot = load("res://scenes/shoots/insect_shoot.tscn")
@onready var world = get_tree().get_first_node_in_group("Mundo")

var speed = 125.0
var max_life_points = 100
var life_points: float = 100
var moving = false
var is_destroying = false
var in_position = false
var is_ship_destroyed = false
var rng = RandomNumberGenerator.new()
var y_position = -1
var x_max_position = -1
var x_min_position = -1 
var direction

signal enemy_has_destroyed(enemy_name: String)

func normal_damage_received(damage_: int):
	if is_destroying:
		return
	life_points -= damage_
	life_bar.set_current_life_points(life_points)
	if life_points <= 0:
			destroy()
	return damage_

func _ready():
	y_position = fore_front.global_position.y - 70
	x_min_position = fore_front.global_position.x - 40
	x_max_position = fore_front.global_position.x + 40
	life_bar.set_max_life_points(max_life_points)
	life_points = max_life_points
	sprite.play("default")
	ship = get_tree().get_first_node_in_group("Ship")
	if ship:
		ship.connect("ship_has_destroyed", process_ship_has_destroyed)
	var mundo_group = get_tree().get_nodes_in_group("Mundo")
	for node in mundo_group:
		node.connect("level_has_completed", destroy)


func process_ship_has_destroyed():
	is_ship_destroyed = true

func _process(delta):
	go_to_position(delta)
	move(delta)

func go_to_position(delta):
	if (global_position.y > y_position):
		global_position.y -= speed * delta
	else:
		in_position = true
		
func move(delta):
	if moving == true:
		if direction == 1:
			global_position.x += speed * delta
		elif direction == 0:
			global_position.x -= speed * delta
		return
	moving = true
	direction = -1
	if position.x < x_min_position:
		direction = 1
	if position.x > x_max_position:
		direction = 0
	if direction == -1:
		direction = rng.randi_range(0,1)
	await get_tree().create_timer(0.3).timeout
	moving = false


func get_real_name():
	return "insect"


func destroy():
	if is_destroying == true:
		return
	action_shape.queue_free()
	is_destroying = true
	life_bar.visible = false
	destroy_audio.play()
	sprite.scale.x = 0.1
	sprite.scale.y = 0.1
	sprite.play("exploit")
	emit_signal("enemy_has_destroyed", get_real_name())
	await get_tree().create_timer(0.8).timeout
	queue_free()


func _on_rotate_timer_timeout():
	sprite.rotation_degrees += 10


func _on_shoot_timer_timeout():
	if is_ship_destroyed || !in_position:
		return
	var shoot_instance = insect_shoot.instantiate()
	shoot_instance.global_position = global_position
	world.add_child(shoot_instance)
