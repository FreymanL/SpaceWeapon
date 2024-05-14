extends Control

var gold: int
@onready var value = $Value

func _ready():
	gold = UserData.user_data.gold
	value.text = str(gold)

func _on_refresh_timeout():
	gold = UserData.user_data.gold
	value.text = str(gold)
