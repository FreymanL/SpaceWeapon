extends Area2D

@export var shoot: PackedScene
@onready var sprite = $Sprite
@onready var life_bar = $LifePointsBar
@onready var collision_shape = $CollisionShape
@onready var audio_destroyed = $DestroyedAudio
@onready var shoot_position = $Shoot/Direction
@onready var life_points_summary = $LifePointsSummary
@onready var booster_manager : Node2D = get_tree().get_first_node_in_group("BoosterManager")
@onready var interaction_manager : Node2D = get_tree().get_first_node_in_group("InteractionManager")
@onready var shoot_timer = $ShootTimer
@onready var world = get_tree().get_first_node_in_group("Mundo")

var speed: float = 250.0
var max_life_points = 1000
var life_points: int
var is_destroying = false
var shoot_is_disabled = 0
var level_completed = false
var wait_before_go = 2.0

signal ship_has_destroyed
signal execute_ability(num)

func _ready():
	world.connect("level_has_completed", set_level_completed)

	
func set_life_bar():

	life_bar.set_max_life_points(max_life_points)
	life_points_summary.text = str(life_points) + "/" + str(max_life_points)

func update_life_bar():
	life_bar.set_current_life_points(life_points)
	life_points_summary.text = str(life_points) + "/" + str(max_life_points)

func set_parameters():
	max_life_points = booster_manager.calculate_ship_life_points(max_life_points)
	life_points = max_life_points
	set_life_bar()
	shoot_timer.wait_time = booster_manager.calculate_ship_attack_speed(shoot_timer.wait_time)
	speed = booster_manager.calculate_ship_speed(speed)

func _process(delta):
	if is_destroying || level_completed:
		return
	if Input.is_action_just_pressed("Ability-1"):
		emit_signal("execute_ability", 0)
	if Input.is_action_just_pressed("Ability-2"):
		emit_signal("execute_ability", 1)
	if Input.is_action_just_pressed("Ability-3"):
		emit_signal("execute_ability", 2)
	if Input.is_action_just_pressed("Ability-4"):
		emit_signal("execute_ability", 3)
	if Input.is_action_just_pressed("Ability-5"):
		emit_signal("execute_ability", 4)

	var directionX = Input.get_axis("ui_left", "ui_right")
	var directionY = Input.get_axis("ui_up", "ui_down")
	if !directionX && !directionY:
		sprite.play("idle")

	if directionX:
		if Input.is_action_pressed("ui_left"):
			sprite.flip_v = false
			global_position.x = max(global_position.x - (speed * delta), 50)
		else:
			sprite.flip_v = true
			global_position.x = min(1230, global_position.x + (speed * delta))
		sprite.play("turn")

	if directionY:
		if Input.is_action_pressed("ui_up"):
			global_position.y = max(global_position.y - (speed * delta), 100)
		else:
			global_position.y = min(global_position.y + (speed * delta), 640)

func destroy():
	audio_destroyed.play()
	is_destroying = true
	collision_shape.queue_free()
	sprite.play("exploit")
	await get_tree().create_timer(2).timeout
	emit_signal("ship_has_destroyed")
	queue_free()

func normal_damage_received(damage):
	if is_destroying || level_completed:
		return
	var real_damage: int = booster_manager.calculate_damage_received(damage)
	life_points -= real_damage
	update_life_bar()
	if life_points <= 0:
		destroy()
	return real_damage

func normal_health_received(health):
	if is_destroying || level_completed:
		return
	var real_health: int = booster_manager.calculate_ship_health(health)
	real_health = min(real_health, max_life_points - life_points)
	life_points += real_health
	update_life_bar()
	return real_health

func set_level_completed():
	level_completed = true
	life_bar.visible = false
	sprite.play("idle")
	sprite.play("bost")
	await get_tree().create_timer(wait_before_go).timeout
	for i in 1000:
		await  get_tree().create_timer(0.01).timeout
		global_position.y -= 1.5

func get_real_name():
	return "Ship"

func _on_shoot_laser_timeout():
	if !is_inside_tree():
		return
	if shoot_is_disabled < 0 || level_completed || is_destroying:
		return
	var laser_shoot = shoot.instantiate()
	var rng = RandomNumberGenerator.new()
	var number = rng.randi_range(0,1000)
	laser_shoot.name =  laser_shoot.name + str(number)
	world.add_child(laser_shoot)
	laser_shoot.global_position = shoot_position.global_position
