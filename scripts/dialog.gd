extends Node2D

@onready var text = $Background/Text
@onready var typing_audio = $TypingAudio
@onready var display_text_timer = $DisplayTextTimer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_display_text_timer_timeout():
	text.visible_ratio += 0.05


func _on_stop_timeout():
	display_text_timer.stop()
	typing_audio.stop()
