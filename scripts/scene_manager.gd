extends Node2D

@onready var main_menu = load("res://scenes/menu_controls/main_menu.tscn")

var current_scene : Node
var current_parameters = {}

func _ready():
	var menu_instance = create_menu_instance()
	add_child(menu_instance)
	current_scene = menu_instance

func _process(_delta):
	var menu_nodes = get_tree().get_nodes_in_group("menu_actions")
	for node in menu_nodes:
		if node.has_signal("go_home") and !node.is_connected("go_home", process_go_home):
			node.connect("go_home", process_go_home)
		if node.has_signal("play_world") and !node.is_connected("play_world", process_play_world):
			node.connect("play_world", process_play_world)

func process_play_world(parameters):
	var world = parameters["world"]
	current_scene.queue_free()
	var next_level = load("res://scenes/worlds/" + world + ".tscn").instantiate()
	await get_tree().create_timer(0.05).timeout #pantalla de carga
	add_child(next_level)
	next_level.set_parameters(parameters)
	current_scene = next_level
	current_parameters = parameters

func process_go_home():
	var menu_instance = create_menu_instance()
	add_child(menu_instance)
	current_scene.queue_free()
	current_scene = menu_instance
	current_parameters = {}

func create_menu_instance():
	var menu_instance = main_menu.instantiate()
	menu_instance.connect("play_world", process_play_world)
	return menu_instance
