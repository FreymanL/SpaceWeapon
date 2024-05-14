extends Control

@onready var store_item = load("res://scenes/menu_controls/store_item.tscn")
@onready var details = $Details
@onready var gold_label = $BoxContainer/GoldLabel
@onready var buy_button : Button = $BuyContainer/Buy
@onready var items_container = $ScrollContainer/ItemsContainer
@onready var store_items

var gold : int
var selected_item : Control

signal back_home()
signal item_bought(item: Control)

func _ready():
	gold = gold_label.gold
	store_items = get_tree().get_nodes_in_group("StoreItem")
	for item in store_items:
		item.queue_free()
	load_store_items()
	
func load_store_items():
	var items = Settings.get_key("items")
	for item_id in items:
		var item_instance = store_item.instantiate()
		items_container.add_child(item_instance)
		item_instance.item_id = item_id
		item_instance.update_item_info()
		item_instance.connect("item_selected", process_item_selected)

func process_item_selected(item: Control):
	details.show_text(item.item_description)
	selected_item = item
	buy_button.show()
	check_buy()
	
func check_buy():
	
	if gold >= selected_item.item_cost:
		buy_button.disabled = false
	else:
		buy_button.disabled = true
	


func _on_buy_focus_entered():
	if gold < selected_item.item_cost:
		return #no enough money
	process_purchase()
	
func process_purchase():
	gold = gold - selected_item.item_cost
	UserData.load_data()
	var user_data = UserData.user_data
	user_data.gold = gold
	if selected_item.item_id == "ability_point":
		user_data.ability_points = user_data.ability_points + 1
	else:
		user_data.abilities[selected_item.item_id] = true
	UserData.user_data = user_data
	UserData.save_data()
	emit_signal("item_bought", selected_item)

func _on_ok_pressed():
	emit_signal("back_home")
