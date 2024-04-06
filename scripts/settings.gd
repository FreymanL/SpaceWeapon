extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
var settings = {
	"mundo" : {
		"num_abilities": 3
	}
}

func get_key(key : String):
	return settings[key]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
