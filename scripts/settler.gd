extends Area2D

@onready var shoot = load("res://scenes/shoots/settler_shoot.tscn")
@onready var misil = load("res://scenes/shoots/settler_misil.tscn")
@onready var sprite = $Sprite
@onready var life_bar = $LifePointsBar
@onready var destroy_audio = $DestroyAudio
@onready var action_shape = $ActionShape
@onready var interaction_manager = get_tree().get_first_node_in_group("InteractionManager")
@onready var shoot1 = $Shoot1
@onready var shoot2 = $Shoot2
@onready var shoot3 = $Shoot3
@onready var destiny1 = $Destiny1
@onready var destiny2 = $Destiny2
@onready var destiny3 = $Destiny3

var speed = 1.0
var max_life_points = 10000
var life_points: float = 10000
var moving = false
var is_destroying = false
var in_position = false
var ship
var is_ship_destroyed = false
var direction
var world
var time_shoot = 1;
signal enemy_has_destroyed(name: String)

func _ready():
	life_bar.set_max_life_points(max_life_points)
	life_points = max_life_points
	sprite.play("default")
	ship = get_tree().get_first_node_in_group("Ship")
	ship.connect("ship_has_destroyed", process_ship_has_destroyed)
	world = get_tree().get_first_node_in_group("Mundo")
	world.connect("level_has_completed", await destroy)
	

func go_to_position():
	if (global_position.y < 100):
		global_position.y += speed
	else:
		in_position = true

func process_ship_has_destroyed():
	is_ship_destroyed = true
	
func destroy():
	if is_destroying == true:
		return
	action_shape.queue_free()
	is_destroying = true
	life_bar.visible = false
	destroy_audio.play()
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

func get_real_name():
	return "settler"

func _process(delta):
	go_to_position()
	move()

func move():
	if direction == 1:
		global_position.x += speed
	elif direction == 0:
		global_position.x -= speed;

func _on_shoot_timer_timeout():
	if is_ship_destroyed:
		return
	time_shoot += 1
	if time_shoot%4 == 0:
		shoot_misil()
	else:
		shoot_laser()
	
func shoot_laser():
	for i in 3:	
		add_laser(shoot1, destiny1)
		add_laser(shoot2, destiny2)
		add_laser(shoot3, destiny3)
		await get_tree().create_timer(0.2).timeout

func add_laser(src: Node2D, destiny: Node2D):
	var instance = shoot.instantiate()
	instance.global_position = src.global_position
	world.add_child(instance)
	instance.dir = src.global_position.direction_to(destiny.global_position)
	instance.look_at(destiny.global_position)
	
func shoot_misil():
	var instance = misil.instantiate()
	instance.global_position = shoot1.global_position
	instance.target = ship.global_position
	world.add_child(instance)
	
	
func _on_move_timer_timeout():
	direction = -1
	if position.x < 300:
		direction = 1
	if position.x > 980:
		direction = 0
	if direction == -1:
		var rng = RandomNumberGenerator.new()
		direction = rng.randi_range(0,1)
