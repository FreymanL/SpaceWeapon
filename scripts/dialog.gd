extends Node2D

@onready var text = $Background/Text
@onready var display_text_timer = $DisplayTextTimer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_display_text_timer_timeout():
	if text.visible_ratio <= 1:
		text.visible_ratio += 0.2

func show_text(text_):
	if text_ == text.text:
		return
	text.visible_ratio = 0
	text.text = text_
