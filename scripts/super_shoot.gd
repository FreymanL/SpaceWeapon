extends CharacterBody2D

@onready var sprite = $Sprite
@onready var audio = $ShootAudio
@export var icon : CompressedTexture2D
@onready var collision_shape = $CollisionShape
var duration = 5.0
var is_active = false
var ship
var cooldown = 20
var damage = 4
var reset = false
func _ready():
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
	queue_free()
	
func get_damage():
	return damage

func crashed():
	pass

func _on_reset_timeout():
	if !reset:
		remove_child(collision_shape)
	else:
		add_child(collision_shape)
	reset = !reset
