extends Node2D

@onready var booster_manager : Node2D = get_tree().get_first_node_in_group("BoosterManager")

var in_cooldown = false
var current_cooldown = 0.0
var max_cooldown
var icon : CompressedTexture2D
var ability: PackedScene
var ability_name
var num
var ship
var world
signal ability_ready()

func _ready():
	ship = get_tree().get_first_node_in_group("Ship")
	ship.connect("execute_ability", process_execute_ability)
	world = get_tree().get_first_node_in_group("Mundo")
	

func load_ability(ability_name_, num_):
	ability = load("res://scenes/abilities/"+ability_name_+".tscn")
	var ability_instance = ability.instantiate()
	max_cooldown = booster_manager.calculate_skill_cooldown(ability_instance.cooldown)
	icon = ability_instance.icon
	ability_name = ability_name_
	num = num_
	add_to_group("Ability" + str(num))

func process_execute_ability(num_ability):
	if num_ability == num:
		execute()

func execute():
	if in_cooldown:
		return
	in_cooldown = true
	current_cooldown = max_cooldown
	var ability_instance = ability.instantiate()
	ability_instance.ship = ship
	var rng = RandomNumberGenerator.new()
	var number = rng.randi_range(0,1000)
	ability_instance.name =  ability_instance.name + str(number)
	world.add_child(ability_instance)

func _on_cooldown_timeout():
	if !in_cooldown:
		return
	if current_cooldown <= 0.0:
		in_cooldown = false
		current_cooldown = 0.0;
	else:
		current_cooldown -= 0.1
