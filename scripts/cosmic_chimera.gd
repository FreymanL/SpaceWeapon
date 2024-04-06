extends CharacterBody2D

@onready var sprite = $Sprite
@onready var destroyed_audio = $DestroyedAudio
@onready var cosmis_chimera_shoot = load("res://scenes/cosmic_chimera_shoot.tscn")
@onready var life_bar = $LifePointsBar
var life_points = 80
var speed = 100
var is_destroying = false
var is_shooting = false
var is_in_position = false
var is_moving = false
var corner = 0
var ship
var damage = 10
var is_ship_destroyed = false
var rng = RandomNumberGenerator.new()
signal cosmic_chimera_has_destroyed

# Called when the node enters the scene tree for the first time.
func _ready():
	life_bar.set_max_life_points(life_points)
	ship = get_tree().get_first_node_in_group("Ship")
	ship.connect("ship_has_destroyed", process_ship_destroyed)
	var mundo_group = get_tree().get_nodes_in_group("Mundo")
	for node in mundo_group:
		node.connect("level_has_completed", await destroy)
	sprite.play("default")
	var rng = RandomNumberGenerator.new()
	corner = rng.randi_range(0,1)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_destroying || is_ship_destroyed:
		return
	go_to_position()
	move()
	check_shoot()
	move_and_slide()


func process_ship_destroyed():
	is_ship_destroyed = true

func go_to_position():
	if corner == 0:
		go_to_left()
	else:
		go_to_right()

func go_to_left():
	if global_position.x < 130:
		is_in_position = true
		velocity.x = move_toward(velocity.x, 0, speed)
	else:
		var dir = Vector2(-2,1)
		velocity = dir * speed

func go_to_right():
	if global_position.x > 1150:
		is_in_position = true
		velocity.x = move_toward(velocity.x, 0, speed)
	else:
		var dir = Vector2(2,1)
		velocity = dir * speed

func move():
	if is_moving == true:
		return
	is_moving = true
	var direction = -1
	if position.y < 100:
		direction = 1
	if position.y > 310:
		direction = 0
	if direction == -1:
		direction = rng.randi_range(0,1)
	if direction == 1:
		velocity.y = speed
	elif direction == 0:
		velocity.y = -speed;
	await get_tree().create_timer(1).timeout
	is_moving = false

func _on_action_area_body_entered(body):
	if is_destroying:
		return
	if "LaserShoot" in body.get_name()  || "SuperShoot" in body.get_name() || "AttackDroneShoot" in body.get_name() || "EnergyBurst" in body.get_name():
		life_points -= body.get_damage()
		life_bar.set_current_life_points(life_points)
		body.crashed()
		if life_points <= 0 && !is_destroying:
			destroy()

func destroy():
	is_destroying = true
	sprite.play("crashed")
	destroyed_audio.play()
	emit_signal("cosmic_chimera_has_destroyed")
	await get_tree().create_timer(0.5).timeout
	queue_free()

func check_shoot():
	if is_shooting:
		return
	is_shooting = true
	

func _on_shoot_timer_timeout():
	if is_ship_destroyed || !is_in_position:
		return
	var shoot_instance = cosmis_chimera_shoot.instantiate()
	var num = rng.randi_range(0,1000)
	shoot_instance.name += str(num)
	shoot_instance.speed = 300
	shoot_instance.damage = damage
	shoot_instance.global_position = $Shoot/Direction.global_position
	get_tree().call_group("Shoots", "add_child", shoot_instance)


func _on_set_direction_timer_timeout():
	if is_ship_destroyed:
		return
	look_at(ship.global_position)
	life_bar.rotation = -rotation
	life_bar.global_position = global_position + Vector2(-25,30)
