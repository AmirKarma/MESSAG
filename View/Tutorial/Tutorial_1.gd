extends Node2D

@onready var building_pit_label : Node = $"bp/Building Pit Label"
@onready var spaceship_label : Node = $"SpaceShip/Spaceship Label"
@onready var shop_label : Node = $"Shop/Shop Label"
@onready var mooneten_game : Node = $"mg_back/Mooneten Game Label"
@onready var moonstone_game : Node = $"mg_back/Moonstone Game Label"
@onready var currency : Node = $"Currency/Currency Label"
@onready var discription : Node = $Background/description
@onready var map_lable : Node = $Map/Map_label

# Called when the node enters the scene tree for the first time.
func _ready():
	_label_visible_false()
	discription.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _label_visible_false():
	building_pit_label.visible = false
	spaceship_label.visible = false
	shop_label.visible = false
	mooneten_game.visible = false
	moonstone_game.visible = false
	currency.visible = false
	discription.visible = false
	map_lable.visible = false


func _on_space_ship_pressed():
	if spaceship_label.visible == false:
		_label_visible_false()
		spaceship_label.visible = true
	else:
		print("Spaceship_Szene")


func _on_shop_pressed():
	if shop_label.visible == false:
		_label_visible_false()
		shop_label.visible = true
	else:
		var shop_tutorial: Node = load("res://Tutorial/Shop_t/Shop_tutorial.tscn").instantiate()
		get_tree().root.add_child(shop_tutorial)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = shop_tutorial


func _on_touch_screen_button_pressed():
	_label_visible_false()
	discription.visible = true
	

func _building_pit():
	if building_pit_label.visible == false:
		_label_visible_false()
		building_pit_label.visible = true
	else:
		var building_t: Node = load("res://Tutorial/Buildingpit_t/Buildingpit_t.tscn").instantiate()
		get_tree().root.add_child(building_t)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = building_t

func _on_building_pits_pressed():
	_building_pit()
func _on_building_pits_2_pressed():
	_building_pit()
func _on_building_pits_3_pressed():
	_building_pit()
func _on_building_pits_4_pressed():
	_building_pit()
func _on_building_pits_5_pressed():
	_building_pit()
func _on_building_pits_6_pressed():
	_building_pit()
func _on_building_pits_7_pressed():
	_building_pit()


func _on_currency_pressed():
	_label_visible_false()
	currency.visible = true


func _on_mg_1_pressed():
	if mooneten_game.visible == false:
		_label_visible_false()
		mooneten_game.visible = true
	else:
		var minigame1_t: Node = load("res://Tutorial/Minigame1/minigame1_t.tscn").instantiate()
		get_tree().root.add_child(minigame1_t)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = minigame1_t


func _on_mg_2_pressed():
	if moonstone_game.visible == false:
		_label_visible_false()
		moonstone_game.visible = true
	else:
		var minigame2_t: Node = load("res://Tutorial/Minigame2/minigame2_t.tscn").instantiate()
		get_tree().root.add_child(minigame2_t)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = minigame2_t


func _on_map_pressed():
	if map_lable.visible == false:
		_label_visible_false()
		map_lable.visible = true
	else:
		var start_m: Node = load("res://Start_Menue/Scene/start_menue.tscn").instantiate()
		get_tree().root.add_child(start_m)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = start_m
