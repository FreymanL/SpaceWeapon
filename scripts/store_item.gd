extends TextureButton

@export var item_id : String

@onready var namelbl = $Name
@onready var cost = $Cost
@onready var description_dialog = get_tree().get_first_node_in_group("StoreDescriptions")
@onready var upgrades_menu = get_tree().get_first_node_in_group("UpgradesMenu")
var item_icon : CompressedTexture2D
var item_cost: int
var item_name: String
var item_description: String
var item_video_example: String

signal item_selected(item: Control)

func _ready():
	upgrades_menu.connect("item_bought", process_item_bought)
		
func update_item_info():
	var item = Settings.get_key("items")[item_id]
	item_icon = load("res://images/abilities/"+item_id+"/icon.png")
	item_name = item.name
	item_description = item.description
	item_video_example = item.video
	UserData.load_data()
	if item_id == "ability_point":
		var num = UserData.user_data.ability_points
		if num >= 35:
			queue_free()
		item_cost = item.cost[num]
	else:
		if UserData.user_data.abilities.has(item_id):
			queue_free()
		item_cost = item.cost
	set_item()

func set_item():
	texture_normal = item_icon
	namelbl.text = item_name
	cost.text = str(item_cost) 

func process_item_bought(item: Control):
	if item.item_name != item_name:
		return
	update_item_info()


func _on_pressed():
	grab_focus()
	emit_signal("item_selected", self)

func _on_mouse_entered():
	grab_focus()
	emit_signal("item_selected", self)
