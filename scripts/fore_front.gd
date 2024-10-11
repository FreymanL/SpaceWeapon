extends Area2D

@onready var sprite = $Sprite
@onready var ship = get_tree().get_first_node_in_group("Ship")
@onready var life_bar = $LifePointsBar
@onready var destroy_audio = $DestroyedAudio
@onready var action_shape = $ActionShape
@onready var interaction_manager: Node2D = get_tree().get_first_node_in_group("InteractionManager")
@onready var insect = load("res://scenes/enemies/insect.tscn")
@onready var world = get_tree().get_first_node_in_group("Mundo")

var speed = 125.0
var max_life_points = 8000
var life_points: float = 8000
var moving = false
var is_destroying = false
var in_position = false
var is_ship_destroyed = false
var rng = RandomNumberGenerator.new()
var y_position = -1
var max_insects = 4
var current_insects = 0

signal enemy_has_destroyed(enemy_name: String)

func normal_damage_received(damage_: int):
	if is_destroying:
		return
	life_points -= damage_
	life_bar.set_current_life_points(life_points)
	if life_points <= 0:
			destroy()
	return damage_


func go_to_position(delta):
	if y_position == -1:
		y_position = rng.randi_range(100,300)
	if (global_position.y < y_position):
		global_position.y += speed * delta
	else:
		in_position = true

func _ready():
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


func _on_rotate_timer_timeout():
	sprite.rotation_degrees += 2

func get_real_name():
	return "fore_front"

func destroy():
	if is_destroying == true:
		return
	action_shape.queue_free()
	is_destroying = true
	life_bar.visible = false
	destroy_audio.play()
	sprite.scale.x = 1.5
	sprite.scale.y = 1.5
	sprite.play("exploit")
	emit_signal("enemy_has_destroyed", get_real_name())
	await get_tree().create_timer(0.8).timeout
	queue_free()


func _on_spawn_timer_timeout():
	if is_ship_destroyed || is_destroying || !in_position || current_insects >= max_insects:
		return
	var insect_instance = insect.instantiate()
	insect_instance.global_position = global_position
	insect_instance.fore_front = self
	current_insects += 1
	world.add_child(insect_instance)
	insect_instance.connect("enemy_has_destroyed", process_insect_destroyed)
	
func process_insect_destroyed(_enemy_name: String):
	current_insects -= 1
