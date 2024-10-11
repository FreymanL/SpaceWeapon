extends TextureProgressBar


var ship

var world
var ability_handler
var ability_ready = false

func _ready():
	world = get_tree().get_first_node_in_group("Mundo")
	world.connect("level_has_completed", queue_free)
	ship = get_tree().get_first_node_in_group("Ship")
	
func connect_ability(num):
	ability_handler = get_tree().get_first_node_in_group("Ability"+str(num))
	texture_progress = ability_handler.icon
	max_value = ability_handler.max_cooldown
	ability_ready = true


func _process(_delta):
	if !ability_ready:
		return
	if ship.is_destroying:
		queue_free()
	else:
		value = ability_handler.max_cooldown - ability_handler.current_cooldown
		

