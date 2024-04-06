extends ProgressBar

# Called when the node enters the scene tree for the first time.

func set_max_life_points(max_points):
	max_value = max_points
	value = max_points

# Called every frame. 'delta' is the elapsed time since the previous frame.
func set_current_life_points(life_points):
	value = life_points
