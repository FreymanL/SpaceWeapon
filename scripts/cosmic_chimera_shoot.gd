extends CharacterBody2D

var speed : int
var is_crashing = false
var damage : int
var ship
var dir : Vector2
@onready var sprite = $Sprite
@onready var action_shape = $ActionArea/ActionShape


func _ready():
	sprite.play("shoot")
	var world = get_tree().get_first_node_in_group("Mundo")
	world.connect("level_has_completed", destroy)
	ship = get_tree().get_first_node_in_group("Ship")
	set_direction()
		
func destroy():
	queue_free()

func set_direction():
	dir = global_position.direction_to(ship.global_position)
	look_at(ship.global_position)

func _process(delta):
	if is_crashing:
		return
	global_position += dir * speed * delta


func _on_visible_on_screen_enabler_2d_screen_exited():
	destroy()

func crashed():
	is_crashing = true
	action_shape.disabled
	scale = Vector2(0.25, 0.25)
	sprite.play("crashed")
	await get_tree().create_timer(0.6).timeout
	destroy() 

func get_damage():
	return damage


func _on_action_area_body_entered(body):
	if "Shoot" in body.get_name():
		return
	if body.get_name() != "Ship" && !("Shield" in body.get_name()) && !("AttackDrone" in body.get_name()):
		return
	body.damage_received(damage)
	crashed()
	
