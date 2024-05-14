extends Node2D

@onready var path_line = load("res://scenes/menu_controls/path_line.tscn")
# Called when the node enters the scene tree for the first time.
func set_paths():
	var nodes = get_tree().get_nodes_in_group("PassiveSkillNode")
	var node_positions = {}
	
	for node in nodes:
		node_positions[node.skill_id] = node.get_vertice()
	for node in nodes:
		if node.prenode != "":
			var line = path_line.instantiate()
			add_child(line)
			line.connect_nodes(node_positions[node.prenode], node.get_vertice())
			node.path_to = line
