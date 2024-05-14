extends Area2D

@onready var sprite = $Sprite
@onready var destroyed_audio = $DestroyedAudio
@onready var cosmis_chimera_shoot = load("res://scenes/shoots/cosmic_chimera_shoot.tscn")
@onready var life_bar = $LifePointsBar
@onready var action_shape = $ActionShape
@onready var interaction_manager: Node2D = get_tree().get_first_node_in_group("InteractionManager")

var max_life_points = 800
var life_points = 800
var speed = 1
var is_destroying = false
var is_shooting = false
var is_in_position = false
var is_moving = false
var corner = 0
var ship
var damage = 10
var is_ship_destroyed = false
var rng = RandomNumberGenerator.new()
var direction
signal enemy_has_destroyed(name: String)

# Called when the node enters the scene tree for the first time.
func _ready():
	life_bar.set_max_life_points(max_life_points)
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
	else:
		var dir = Vector2(-2,1)
		global_position += dir * speed

func go_to_right():
	if global_position.x > 1150:
		is_in_position = true
	else:
		var dir = Vector2(2,1)
		global_position += dir * speed

func move():
	if is_moving == true:
		if direction == 1:
			global_position.y += speed
		elif direction == 0:
			global_position.y  -=speed;
		return
	is_moving = true
	direction = -1
	if position.y < 100:
		direction = 1
	if position.y > 310:
		direction = 0
	if direction == -1:
		direction = rng.randi_range(0,1)
	await get_tree().create_timer(1).timeout
	is_moving = false


func destroy():
	is_destroying = true
	action_shape.queue_free()
	sprite.play("crashed")
	destroyed_audio.play()
	emit_signal("enemy_has_destroyed", get_real_name())
	await get_tree().create_timer(0.5).timeout
	queue_free()


func _on_shoot_timer_timeout():
	if is_ship_destroyed || !is_in_position:
		return
	var shoot_instance = cosmis_chimera_shoot.instantiate()
	var num = rng.randi_range(0,1000)
	shoot_instance.name += str(num)
	shoot_instance.global_position = $Shoot/Direction.global_position
	get_tree().call_group("Mundo", "add_child", shoot_instance)
	interaction_manager.connect_with(shoot_instance)

func _on_set_direction_timer_timeout():
	if is_ship_destroyed:
		return
	look_at(ship.global_position)
	life_bar.rotation = -rotation
	life_bar.global_position = global_position + Vector2(-25,30)

func get_real_name():
	return "cosmic_chimera"
	
func normal_damage_received(damage_: int):
	if is_destroying:
		return
	life_points -= damage_
	life_bar.set_current_life_points(life_points)
	if life_points <= 0:
		destroy()
	return damage_
