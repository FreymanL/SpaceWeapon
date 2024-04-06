extends CharacterBody2D

@onready var sprite = $Sprite
@onready var audio = $Audio
@export var icon : CompressedTexture2D
@onready var collision_shape = $CollisionShape2D
var duration = 10
var is_active = false
var ship
var cooldown = 20
var damage = 6
var reset = false
var boost_speed = 1.5

func _ready():
	sprite.play("default")
	ship.collision_shape.disabled = true
	ship.SPEED *= boost_speed
	execute()

func _process(delta):
	if ship.is_destroying || ship.level_completed:
		destroy()
	global_position.x = ship.global_position.x
	global_position.y = ship.global_position.y

func execute():
	audio.play()
	is_active = true
	ship.shoot_is_disabled = true
	sprite.play("growing")
	await get_tree().create_timer(0.2).timeout
	sprite.play("destroying")
	await get_tree().create_timer(duration - 0.2).timeout
	is_active = false
	ship.shoot_is_disabled = false
	destroy()

func destroy():
	ship.SPEED *= (1 / boost_speed)
	queue_free()
	
func get_damage():
	return damage

func crashed():
	pass

func _on_timer_timeout():
	if !reset:
		remove_child(collision_shape)
	else:
		add_child(collision_shape)
	reset = !reset
