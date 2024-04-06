extends CharacterBody2D

var speed = 1500
var damage = 10
var is_crashing = false
var scale_setted = Vector2(2.3,2.3)

@onready var sprite = $Sprite
@onready var shoot_audio = $ShootAudio
@onready var collision_shape = $CollisionShape

func _ready():
	sprite.play("default")
	shoot_audio.play()
	scale = scale_setted
	var mundo_group = get_tree().get_nodes_in_group("Mundo")
	for node in mundo_group:
		node.connect("level_has_completed", queue_free)


func _process(delta):
	if is_crashing == false:
		global_position.y -= speed * delta

func _on_visible_on_screen_enabler_2d_screen_exited():
	destroy()

func crashed():
	is_crashing = true
	collision_shape.disabled
	scale.x = 0.1
	scale.y = 0.1
	sprite.play("crashed")
	await get_tree().create_timer(0.1).timeout
	destroy() 

func destroy():
	queue_free()
	
func get_damage():
	return damage
