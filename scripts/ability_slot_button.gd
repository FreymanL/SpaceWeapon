extends TextureButton

@onready var pressed_audio = $BtnPressedAudio

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var num : int
signal button_has_pressed(num: int)

func _on_pressed():
	pressed_audio.play()
	emit_signal("button_has_pressed", num)
