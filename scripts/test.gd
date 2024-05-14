extends Node2D

@onready var astropajo_enemy = load("res://scenes/enemies/astropajo.tscn")
@onready var cosmic_chimera_enemy = load("res://scenes/enemies/cosmic_chimera.tscn")
@onready var game_over_window = load("res://scenes/menu_controls/game_over.tscn")
@onready var level_completed_window = load("res://scenes/menu_controls/level_completed.tscn")
@onready var ability_handler = load("res://scenes/in_game_items/ability_handler.tscn")
@onready var ability_icon = load("res://scenes/in_game_items/ability_icon.tscn")
@onready var ability_icon_container = $AbilityIconsContainer
@onready var progress = $ProgressBar
@onready var background = $Lvl1Background
@onready var audio_background = $AudioBackGround
@onready var ship = $Ship
@onready var signals = $signals
@onready var game_settings = load("res://scenes/settings.tscn").instantiate()
@onready var booster_manager = $BoostersManager
var MAX_COSMIC_CHIMERA = 3
var TARGET_COSMIC_CHIMERA = 10
var astropajos_killed_to_spawn = 15

const TARGET_DESTROYED_ASTROPAJOS = 30
const MAX_ASTROPAJOS = 3
var NUM_ABILITIES = 3

var cosmic_chimeras_count = 0
var astropajos_count = 0
var destroyed_astropajos = 0
var destroyed_cosmic_chimeras = 0
var level_completed = false
var level_completed_cooldown = 3.0
var respawn_cooldown = false
var waiting = 2.0
var is_game_over = false
var game_over_cooldown = 3.0
var start = false
var parameters = {}
var world_info

signal level_has_completed

func _ready():
	world_info = game_settings.get_key("test")
	NUM_ABILITIES = world_info["num_abilities"]
	play_music()
	progress.max_value = TARGET_DESTROYED_ASTROPAJOS + TARGET_COSMIC_CHIMERA
	progress.value = 0
	ship.connect("ship_has_destroyed", set_game_over)



func _process(_delta):
	if !start:
		return
	check_spawn_astropajos()

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

func check_spawn_astropajos():
	if astropajos_count >= MAX_ASTROPAJOS || level_completed || respawn_cooldown || destroyed_astropajos > TARGET_DESTROYED_ASTROPAJOS:
		return
	respawn_cooldown = true
	var spawned = astropajo_enemy.instantiate()
	var rng = RandomNumberGenerator.new()
	var positionX = rng.randf_range(0,1100)
	var positionY = -100
	spawned.global_position = Vector2(positionX,positionY)
	astropajos_count += 1
	add_child(spawned)
	spawned.connect("astropajo_has_destroyed", process_astropajo_destroyed)
	await get_tree().create_timer(0.5).timeout
	respawn_cooldown = false


func set_game_over():
	is_game_over = true

func game_over():
	audio_background.stop()
	var gow = game_over_window.instantiate()
	gow.set_parameters(parameters)
	add_child(gow)

func show_level_completed():
	var lcw = level_completed_window.instantiate()
	add_child(lcw)

func play_music():
	await get_tree().create_timer(1).timeout
	audio_background.play()

func _on_timer_timeout():
	background.global_translate(Vector2(0,1))
	if is_game_over && game_over_cooldown > 0:
		game_over_cooldown -= 0.1
		if game_over_cooldown  <= 0:
			game_over()
	if level_completed && level_completed_cooldown > 0:
		level_completed_cooldown -= 0.1
		if level_completed_cooldown <= 0:
			show_level_completed()
	if waiting > 0:
		waiting -= 0.1
		if waiting <= 0:
			start = true


func _on_cosmic_chimera_spawn_timeout():
	if (cosmic_chimeras_count >= MAX_COSMIC_CHIMERA):
		return
	if level_completed:
		return
	if destroyed_astropajos < astropajos_killed_to_spawn:
		return
	if destroyed_cosmic_chimeras > TARGET_COSMIC_CHIMERA:
		return
	var spawned = cosmic_chimera_enemy.instantiate()
	spawned.global_position = Vector2(640,-50)
	cosmic_chimeras_count += 1
	add_child(spawned)
	spawned.connect("cosmic_chimera_has_destroyed", process_cosmic_chimera_has_destroyed)

func process_cosmic_chimera_has_destroyed():
	cosmic_chimeras_count -= 1
	destroyed_cosmic_chimeras += 1
	check_progress()

func process_astropajo_destroyed():
	astropajos_count -= 1
	destroyed_astropajos += 1
	check_progress()

func check_progress():
	if level_completed:
		return
	progress.value = min(destroyed_astropajos, TARGET_DESTROYED_ASTROPAJOS) + min(destroyed_cosmic_chimeras, TARGET_COSMIC_CHIMERA)
	if destroyed_astropajos >= TARGET_DESTROYED_ASTROPAJOS && destroyed_cosmic_chimeras >= TARGET_COSMIC_CHIMERA:
		level_completed = true
		emit_signal("level_has_completed")

