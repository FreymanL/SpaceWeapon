extends Node2D

var gold: int
var rewards = {}

@onready var world = get_tree().get_first_node_in_group("Mundo")
@onready var delta = load("res://scenes/in_game_items/delta.tscn")
@onready var ship = get_tree().get_first_node_in_group("Ship")
func _ready():
	world.connect("game_over", save_rewards)
	world.connect("level_has_completed", save_rewards)
	gold = 0
	rewards = Settings.get_key("enemies")
	
var reward_process_factory = {
	"gold": "process_gold_earned",
}

func _process(_delta):
	var enemies = get_tree().get_nodes_in_group("Enemy")
	for enemy in enemies:
		if !enemy.is_connected("enemy_has_destroyed", process_enemy_destroyed):
			enemy.connect("enemy_has_destroyed", process_enemy_destroyed)


func process_enemy_destroyed(enemy_name: String):
	for key in rewards[enemy_name]:
		call(reward_process_factory[key], rewards[enemy_name].gold)
	
func process_gold_earned(gold_: int):
	gold += gold_
	show_gold(gold_)

func save_rewards():
	UserData.user_data.gold += gold
	UserData.save_data()
	
func show_gold(gold_):
	var delta_instance = delta.instantiate()
	if ship:
		delta_instance.global_position = ship.global_position
	world.add_child(delta_instance)
	delta_instance.show_gold(gold_)
	
