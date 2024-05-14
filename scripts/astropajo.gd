extends Area2D

@onready var astropajo_shoot = load("res://scenes/shoots/astropajo_shoot.tscn")
@onready var sprite = $Sprite
@onready var life_bar = $LifePointsBar
@onready var destroy_audio = $DestroyAudio
@onready var action_shape = $ActionShape
@onready var interaction_manager: Node2D = get_tree().get_first_node_in_group("InteractionManager")

var speed = 2.0
var max_life_points = 400
var life_points: float = 400
var moving = false
var is_destroying = false
var in_position = false
var ship
var is_ship_destroyed = false
var direction

signal enemy_has_destroyed(enemy_name: String)

func _ready():
	life_bar.set_max_life_points(max_life_points)
	life_points = max_life_points
	sprite.play("default")
	ship = get_tree().get_first_node_in_group("Ship")
	if ship:
		ship.connect("ship_has_destroyed", process_ship_has_destroyed)
	var mundo_group = get_tree().get_nodes_in_group("Mundo")
	for node in mundo_group:
		node.connect("level_has_completed", await destroy)

func _process(delta):
	if is_ship_destroyed:
		return
	go_to_position()
	move()

func process_ship_has_destroyed():
	is_ship_destroyed = true

func go_to_position():
	if (global_position.y < 100):
		global_position.y += speed
	else:
		in_position = true

func move():
	if moving == true:
		if direction == 1:
			global_position.x += speed
		elif direction == 0:
			global_position.x -= speed;
		return
	moving = true
	direction = -1
	if position.x < 300:
		direction = 1
	if position.x > 980:
		direction = 0
	if direction == -1:
		var rng = RandomNumberGenerator.new()
		direction = rng.randi_range(0,1)
	await get_tree().create_timer(1).timeout
	moving = false

func destroy():
	if is_destroying == true:
		return
	action_shape.queue_free()
	is_destroying = true
	life_bar.visible = false
	destroy_audio.play()
	sprite.scale.x = 0.25
	sprite.scale.y = 0.25
	sprite.play("exploit")
	emit_signal("enemy_has_destroyed", get_real_name())
	await get_tree().create_timer(1).timeout
	queue_free()


func normal_damage_received(damage_: int):
	if is_destroying:
		return
	life_points -= damage_
	life_bar.set_current_life_points(life_points)
	if life_points <= 0:
			destroy()
	return damage_


func _on_shoot_timer_timeout():
	if in_position == false || is_destroying || is_ship_destroyed:
		return
	shoot_laser()
	
	
func shoot_laser():
	var laser_shoot = astropajo_shoot.instantiate()
	var rng = RandomNumberGenerator.new()
	var number = rng.randi_range(0,1000)
	laser_shoot.name =  laser_shoot.name + str(number)
	laser_shoot.global_position = $Shoot/Direction.global_position
	get_tree().call_group("Mundo", "add_child", laser_shoot)

func get_real_name():
	return "astropajo"
