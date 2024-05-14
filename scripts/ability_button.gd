extends TextureButton

var ability_id : String

signal ability_selected(ability: TextureButton)

func set_ability(ability_id_: String):
	ability_id = ability_id_
	texture_normal = load("res://images/abilities/"+ability_id+"/icon.png")

func _on_pressed():
	emit_signal("ability_selected", self)
