extends Area2D

@onready var sprite = $Sprite

@export var attack_drone_shoot : PackedScene
@export var icon = CompressedTexture2D

@onready var life_bar = $LifePointsBar
@onready var collision_shape = $CollisionShape2D
@onready var audio_destroyed = $AudioDestroyed
@onready var start_position = $SpawnPosition

@onready var delta = load("res://scenes/delta.tscn")
@onready var booster_manager = get_tree().get_first_node_in_group("BoosterManager")

var speed = 100
var current_enemy
var is_ship_destroyed = false
var rng = RandomNumberGenerator.new()
var cooldown = 10
var ship
var max_life_points = 300
var life_points = 300
var is_destroying = false
var duration = 0.0

func _ready():
	var world = get_tree().get_first_node_in_group("Mundo")
	world.connect("level_has_completed", destroy)
	var ship = get_tree().get_first_node_in_group("Ship")
	global_position = ship.global_position
	global_position = start_position.global_position
	sprite.play("default")
	max_life_points = booster_manager.calculate_drone_life_points(max_life_points)
	life_bar.max_value = max_life_points
	life_points = max_life_points
	life_bar.value = life_points

func _process(delta):
	life_bar.rotation = -rotation
	life_bar.global_position = global_position + Vector2(-25,30)
	if current_enemy != null:
		var dir = global_position.x - current_enemy.global_position.x
		if dir > 0:
			global_position.x -= speed * delta
		else:
			global_position.x += speed * delta

func _on_timer_timeout():
	if is_destroying:
		return
	if current_enemy != null:
		look_at(current_enemy.global_position)
		shoot()
	else:
		find_target()


func find_target():
	var new_enemy = get_tree().get_first_node_in_group("Enemy")
	if new_enemy == null:
		return
	current_enemy = new_enemy
	
func shoot():
	if is_ship_destroyed:
		return
	var shoot_instance = attack_drone_shoot.instantiate()
	var num = rng.randi_range(0,1000)
	shoot_instance.name += str(num)
	shoot_instance.current_target = current_enemy
	shoot_instance.global_position = $Shoot/Direction.global_position
	get_tree().call_group("Mundo", "add_child", shoot_instance)


func normal_damage_received(damage):
	if is_destroying:
		return
	var real_damage: float = booster_manager.calculate_drone_damage_received(damage)
	life_points -= real_damage
	update_life_bar()
	if life_points <= 0:
		destroy()
	return real_damage

func update_life_bar():
	life_bar.set_current_life_points(life_points)

func get_health(health):
	life_points = min(life_points + health, max_life_points)
	life_bar.set_current_life_points(life_points)
	show_health(health)

func show_health(health):
	var delta_instance = delta.instantiate()
	delta_instance.global_position = global_position
	get_tree().call_group("Mundo", "add_child", delta_instance)
	delta_instance.show_health(health)
	
func destroy():
	audio_destroyed.play()
	is_destroying = true
	collision_shape.disabled
	scale = Vector2(0.1,0.1)
	sprite.play("exploit")
	await get_tree().create_timer(0.8).timeout
	queue_free()

func get_real_name():
	return "AttackDrone"
