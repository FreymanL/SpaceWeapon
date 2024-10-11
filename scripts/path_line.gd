extends Line2D

var current_path_color : Color = "a3a3a3"
var path_color_inactive : Color = "a3a3a3"
var path_color_active : Color = "ffffff"
var node_from_id
var node_to_id
var from_node : Vector2
var to_node : Vector2

func _draw():
	draw_line(from_node, to_node, current_path_color, 3)
	
func connect_nodes(from_node_ : Vector2, to_node_: Vector2):
	from_node = from_node_
	to_node = to_node_

func active_path():
	current_path_color = path_color_active
	
func inactive_path():
	current_path_color = path_color_inactive
