extends CharacterBody2D

@export var shoot: PackedScene
@onready var sprite = $Sprite
@onready var life_bar = $LifePointsBar
@onready var collision_shape = $CollisionShape
@onready var audio_destroyed = $DestroyedAudio
@onready var shoot_position = $Shoot/Direction
@onready var delta = load("res://scenes/delta.tscn")


var SPEED = 300.0
var MAX_LIFE_POINTS = 100
var life_points = 100
var is_destroying = false
var shoot_is_disabled = false

var level_completed = false
var wait_before_go = 2.0

signal ship_has_destroyed
signal execute_ability(num)

func _ready():
	life_bar.set_max_life_points(MAX_LIFE_POINTS)
	var world = get_tree().get_first_node_in_group("Mundo")
	world.connect("level_has_completed", set_level_completed)

func _process(_delta):
	if is_destroying || level_completed:
		return

	if Input.is_action_just_pressed("Ability-1"):
		emit_signal("execute_ability", 0)
	if Input.is_action_just_pressed("Ability-2"):
		emit_signal("execute_ability", 1)
	if Input.is_action_just_pressed("Ability-3"):
		emit_signal("execute_ability", 2)

	var directionX = Input.get_axis("ui_left", "ui_right")
	var directionY = Input.get_axis("ui_up", "ui_down")
	if !directionX && !directionY:
		sprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if directionX:
		if Input.is_action_pressed("ui_left"):
			sprite.flip_v = false
		else:
			sprite.flip_v = true
		velocity.x = directionX * SPEED
		sprite.play("turn")

	if directionY:
		velocity.y = directionY * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()

func destroy():
	audio_destroyed.play()
	is_destroying = true
	collision_shape.disabled
	sprite.play("exploit")
	await get_tree().create_timer(2).timeout
	emit_signal("ship_has_destroyed")
	queue_free()

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

func set_level_completed():
	level_completed = true
	life_bar.visible = false
	sprite.play("idle")
	sprite.play("bost")
	await get_tree().create_timer(wait_before_go).timeout
	velocity.y = -200
	velocity.x = 0
	for i in 1000:
		await  get_tree().create_timer(0.01).timeout
		move_and_slide()

func _on_shoot_timer_timeout():
	if shoot_is_disabled || level_completed:
		return
	var laser_shoot = shoot.instantiate()
	laser_shoot.global_position = shoot_position.global_position
	get_tree().call_group("Mundo", "add_child", laser_shoot)
