extends CharacterBody2D

var velocidad : int
var is_crashing = false
var damage : int

@onready var sprite = $Sprite
@onready var action_shape =  $ActionArea/ActionShape


func _ready():
	sprite.play("default")
	var mundo_group = get_tree().get_nodes_in_group("Mundo")
	for node in mundo_group:
		node.connect("level_has_completed", destroy)

func destroy():
	queue_free()

func _process(delta):
	if is_crashing:
		return
	global_position.y += velocidad * delta

func _on_visible_on_screen_enabler_2d_screen_exited():
	destroy()

func crashed():
	is_crashing = true
	action_shape.disabled
	sprite.play("crashed")
	await get_tree().create_timer(0.6).timeout
	destroy()

func get_damage():
	return damage


func _on_action_area_body_entered(body):
	print(body.get_name())
	if "Shoot" in body.get_name():
		return
	if body.get_name() != "Ship" && !("Shield" in body.get_name()) && !("AttackDrone" in body.get_name()):
		return
	body.damage_received(damage)
	crashed()
