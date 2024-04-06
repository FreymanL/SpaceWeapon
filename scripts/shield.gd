extends CharacterBody2D

@onready var sprite = $Sprite
@export var icon : CompressedTexture2D
@onready var hit = $HitAudio
var ship
var cooldown = 40
var damage_absorbed = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	ship = get_tree().get_first_node_in_group("Ship")
	sprite.play("ready")
	ship.collision_shape.disabled = true
	

func _process(delta):
	if ship.is_destroying || ship.level_completed:
		queue_free()
	global_position = ship.global_position

func _on_execution_timer_timeout():
	ship.collision_shape.disabled = false
	ship.get_health(damage_absorbed*0.1)
	print(damage_absorbed)
	queue_free()
	
func damage_received(damage):
	damage_absorbed += damage
	hit.play()
	sprite.modulate = "ffffff"
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = "ffffff76"
