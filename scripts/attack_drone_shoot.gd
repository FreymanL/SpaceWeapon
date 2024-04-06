extends CharacterBody2D

var speed = 1000
var damage = 10
var scale_setted = Vector2(0.5,0.5)
var current_target
var world_group
var dir
@onready var sprite = $Sprite
@onready var collision_shape = $CollisionShape


func _ready():
	sprite.play("default")
	scale = scale_setted
	world_group = get_tree().get_first_node_in_group("Mundo")
	world_group.connect("level_has_completed", queue_free)


func _process(delta):
	if current_target != null:
		dir = global_position.direction_to(current_target.global_position)
	if dir != null:
		global_position += dir * speed * delta
	else:
		queue_free()


func _on_visible_on_screen_enabler_2d_screen_exited():
	destroy()

func crashed():
	destroy() 

func destroy():
	queue_free()
	
func get_damage():
	return damage

	
