extends CharacterBody2D

@onready var astropajo_shoot = load("res://scenes/astropajo_shoot.tscn")
@onready var sprite = $Sprite
@onready var life_bar = $LifePointsBar
@onready var destroy_audio = $DestroyAudio

const SPEED = 300.0
const damage = 10

var moving = false
var signals
var destroying = false
var shooting = false
var in_position = false
var life_points = 30
var ship
var is_ship_destroyed = false
signal astropajo_has_destroyed

func _ready():
	life_bar.set_max_life_points(life_points)
	sprite.play("default")
	ship = get_tree().get_first_node_in_group("Ship")
	ship.connect("ship_has_destroyed", process_ship_has_destroyed)
	var mundo_group = get_tree().get_nodes_in_group("Mundo")
	for node in mundo_group:
		node.connect("level_has_completed", await destroy)
	
func _process(delta):
	if is_ship_destroyed:
		return
	go_to_position()
	move()
	check_shoot()
	move_and_slide()

func process_ship_has_destroyed():
	is_ship_destroyed = true

func go_to_position():
	if (global_position.y < 100):
		velocity.y = SPEED
	else:
		in_position = true
		velocity.y = move_toward(velocity.y, 0, SPEED)

func move():
	if moving == true:
		return
	moving = true
	var direction = -1
	if position.x < 300:
		direction = 1
	if position.x > 980:
		direction = 0
	if direction == -1:
		var rng = RandomNumberGenerator.new()
		direction = rng.randi_range(0,1)
	if direction == 1:
		velocity.x = SPEED
	elif direction == 0:
		velocity.x = -SPEED;
	await get_tree().create_timer(1).timeout
	moving = false

func check_shoot():
	if shooting == true || in_position == false || destroying:
		return
	shooting = true
	shoot_laser()
	await get_tree().create_timer(2).timeout
	shooting = false

func shoot_laser():
	var laser_shoot = astropajo_shoot.instantiate()
	var rng = RandomNumberGenerator.new()
	var number = rng.randi_range(0,1000)
	laser_shoot.name =  laser_shoot.name + str(number)
	laser_shoot.damage = 10
	laser_shoot.velocidad = 500
	laser_shoot.global_position = $Shoot/Direction.global_position
	get_tree().call_group("Shoots", "add_child", laser_shoot)

func _on_area_2d_body_entered(body):
	if destroying:
		return
	if "LaserShoot" in body.get_name()  || "SuperShoot" in body.get_name() || "AttackDroneShoot" in body.get_name() || "EnergyBurst" in body.get_name():
		life_points -= body.get_damage()
		life_bar.set_current_life_points(life_points)
		body.crashed()
		if life_points <= 0:
			destroy()


func destroy():
	if destroying == true:
		return
	destroying = true
	life_bar.visible = false
	destroy_audio.play()
	sprite.scale.x = 0.25
	sprite.scale.y = 0.25
	sprite.play("exploit")
	emit_signal("astropajo_has_destroyed")
	await get_tree().create_timer(1).timeout
	queue_free()

