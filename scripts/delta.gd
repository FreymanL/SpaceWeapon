extends Node2D

@onready var num = $Num

var red : Color = "ff0000"
var green : Color = "1eff00"
var gold : Color = "ffd900"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	global_position.y -= 1

func show_damage(delta):
	num.label_settings.set_font_color(red)
	num.text = '-' + str(delta)
	
func show_damage_enemy(delta):
	num.label_settings.set_font_color(red)
	num.text = '-' + str(delta)
	
func show_health(delta):
	num.label_settings.set_font_color(green)
	num.text = '+' + str(delta)
	
func show_gold(delta):
	num.label_settings.set_font_color(gold)
	num.text = '+' + str(delta)

func _on_timer_timeout():
	queue_free()
