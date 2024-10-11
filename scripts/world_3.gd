extends Node2D

@onready var astropajo_enemy = load("res://scenes/enemies/astropajo.tscn")
@onready var cosmic_chimera_enemy = load("res://scenes/enemies/cosmic_chimera.tscn")
@onready var settler_enemy = load("res://scenes/enemies/settler.tscn")
@onready var game_settings = load("res://scenes/settings.tscn").instantiate()
@onready var ability_icon = load("res://scenes/in_game_items/ability_icon.tscn")
@onready var game_over_window = load("res://scenes/menu_controls/game_over.tscn")
@onready var level_completed_window = load("res://scenes/menu_controls/level_completed.tscn")
@onready var ability_handler = load("res://scenes/in_game_items/ability_handler.tscn")

@onready var booster_manager = $BoostersManager
@onready var background = $Background
@onready var progress = $ProgressBar
@onready var ship = $Ship
@onready var ability_icon_container = $AbilityIconsContainer

signal level_has_completed
signal game_over

const TARGET_DESTROYED_ENEMIES = 69
var destroyed_enemies = 0

var start = false
var level_completed = false
var is_game_over = false
var game_over_cooldown = 3.0
var level_completed_cooldown = 3.0
var NUM_ABILITIES: int
var world_info
var parameters = {}
var num_active_enemies = 0
var rest_between_waves = 2
var waves = {
	1: "process_wave_1",
	2: "process_wave_2",
	3: "process_wave_3",
	4: "process_wave_4",
	5: "process_wave_5",
	6: "process_wave_6",
	7: "process_wave_7",
	8: "process_wave_8",
	9: "process_wave_9",
	10: "process_wave_10",
}

var current_wave: int = 0

func _ready():
	world_info = game_settings.get_key("worlds")["world_3"]
	NUM_ABILITIES = world_info["num_abilities"]
	progress.max_value = TARGET_DESTROYED_ENEMIES
	progress.value = 0
	ship.connect("ship_has_destroyed", set_game_over)
	process_next_wave()

func set_parameters(params):
	parameters = params
	print(params)
	booster_manager.execute_boosters(parameters["skills_tree"])
	for i in NUM_ABILITIES:
		var ability_handler_instance = ability_handler.instantiate()
		add_child(ability_handler_instance)
		ability_handler_instance.load_ability(params["abilities"][i], i)
		var ability_icon_instance = ability_icon.instantiate()
		ability_icon_container.add_child(ability_icon_instance)
		ability_icon_instance.connect_ability(i)

	ship.set_parameters()

func _on_timer_timeout():
	background.global_translate(Vector2(0,1))
	if background.global_position.y >= 1500:
		background.global_position.y = -775

func process_next_wave():
	if current_wave == len(waves):
		process_level_completed()
		emit_signal("level_has_completed")
		return
	await get_tree().create_timer(rest_between_waves).timeout
	current_wave+=1
	call(waves[current_wave])

func process_wave_1():
	spawn_astropajo(3)
	
func process_wave_2():
	spawn_astropajo(3)
	spawn_cosmic_chimera(2)

func process_wave_3():
	spawn_astropajo(3)
	spawn_cosmic_chimera(2)

func process_wave_4():
	spawn_astropajo(4)
	spawn_cosmic_chimera(3)

func process_wave_5():
	spawn_astropajo(4)
	spawn_cosmic_chimera(3)
	
func process_wave_6():
	spawn_astropajo(3)
	spawn_cosmic_chimera(5)
	
func process_wave_7():
	spawn_astropajo(6)
	spawn_cosmic_chimera(4)

func process_wave_8():
	spawn_astropajo(7)
	spawn_cosmic_chimera(4)
	
func process_wave_9():
	spawn_astropajo(10)
	spawn_cosmic_chimera(2)
	
func process_wave_10():
	spawn_settler(1)


func spawn_astropajo(num: int):
	for i in num:
		var spawned = astropajo_enemy.instantiate()
		var rng = RandomNumberGenerator.new()
		var positionX = rng.randf_range(0,1100)
		var positionY = -100
		spawned.global_position = Vector2(positionX,positionY)
		add_child(spawned)
		spawned.connect("enemy_has_destroyed", process_enemy_destroyed)
		num_active_enemies += 1

func spawn_settler(num: int):
	for i in num:
		var spawned = settler_enemy.instantiate()
		spawned.global_position = Vector2(640,-50)
		add_child(spawned)
		spawned.connect("enemy_has_destroyed", process_enemy_destroyed)
		num_active_enemies += 1


func spawn_cosmic_chimera(num: int):
	for i in num:
		var spawned = cosmic_chimera_enemy.instantiate()
		spawned.global_position = Vector2(640,-50)
		add_child(spawned)
		spawned.connect("enemy_has_destroyed", process_enemy_destroyed)
		num_active_enemies += 1

func process_enemy_destroyed(_enemy_name: String):
	destroyed_enemies += 1
	num_active_enemies -= 1
	check_progress()

func check_progress():
	if level_completed:
		return
	if  num_active_enemies == 0:
		process_next_wave()
	progress.value = destroyed_enemies

func set_game_over():
	is_game_over = true
	emit_signal("game_over")
	await get_tree().create_timer(game_over_cooldown).timeout
	var gow = game_over_window.instantiate()
	gow.set_parameters(parameters)
	add_child(gow)
	
func process_level_completed():
	level_completed = true
	update_user_data()
	await get_tree().create_timer(level_completed_cooldown).timeout
	var lcw = level_completed_window.instantiate()
	add_child(lcw)

func update_user_data():
	UserData.user_data.current_level = max(UserData.user_data.current_level, world_info.num + 1)
	UserData.save_data()
