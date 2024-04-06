extends Node2D

@onready var main_menu = load("res://scenes/main_menu.tscn")
@onready var world1 = load("res://scenes/mundo.tscn")

var current_scene
var current_parameters = {}

func _ready():
	var menu_instance = create_menu_instance()
	add_child(menu_instance)
	current_scene = menu_instance

func _process(delta):
	var menu_nodes = get_tree().get_nodes_in_group("menu_actions")
	for node in menu_nodes:
		node.connect("go_home", process_go_home)
		node.connect("play_world", process_play_world)

func process_play_world(parameters):
	var world = parameters["world"]
	current_scene.queue_free()
	var next_level = load("res://scenes/" + world + ".tscn").instantiate()
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
