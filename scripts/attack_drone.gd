extends CharacterBody2D

@onready var sprite = $Sprite

@export var attack_drone_shoot : PackedScene
@export var icon = CompressedTexture2D

@onready var life_bar = $LifePointsBar
@onready var collision_shape = $CollisionShape2D
@onready var delta = load("res://scenes/delta.tscn")
@onready var audio_destroyed = $AudioDestroyed
@onready var start_position = $SpawnPosition

var speed = 100
var current_enemy
var is_ship_destroyed = false
var rng = RandomNumberGenerator.new()
var cooldown = 10
var ship
var MAX_LIFE_POINTS = 30
var life_points = 30
var is_destroying = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var world = get_tree().get_first_node_in_group("Mundo")
	world.connect("level_has_completed", destroy)
	var ship = get_tree().get_first_node_in_group("Ship")
	global_position = ship.global_position
	global_position = start_position.global_position
	velocity.y = 0
	sprite.play("default")
	life_bar.max_value = MAX_LIFE_POINTS
	life_bar.value = life_points
# Called every frame. 'delta' is the elapsed time since the previous frame.
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
	get_tree().call_group("Shoots", "add_child", shoot_instance)

func damage_received(damage):
	if is_destroying:
		return
	life_points -= damage
	life_bar.set_current_life_points(life_points)
	show_damage(damage)
	if life_points <= 0:
		destroy()

func show_damage(damage):
	var delta_instance = delta.instantiate()
	delta_instance.global_position = global_position
	get_tree().call_group("Mundo", "add_child", delta_instance)
	delta_instance.show_damage(damage)

func get_health(health):
	life_points = min(life_points + health, MAX_LIFE_POINTS)
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
