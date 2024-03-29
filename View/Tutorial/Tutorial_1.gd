## This script manages the visibility of various labels in the scene and handles user interactions
## with specific elements such as the spaceship, shop, building pits, currency, and minigames. 
## It allows the player to toggle the visibility of different labels by pressing corresponding buttons.
## Additionally, pressing certain buttons triggers scene transitions or instantiates tutorial scenes.
## The script also provides functionality for hiding labels and setting them visible again as needed.

extends Node2D


# References to various labels in the scene

## Reference to the label for the building pit in the scene.
@onready var building_pit_label: Node = $"bp/Building Pit Label"

## Reference to the label for the spaceship in the scene.
@onready var spaceship_label: Node = $"SpaceShip/Spaceship Label"

## Reference to the label for the shop in the scene.
@onready var shop_label: Node = $"Shop/Shop Label"

## Reference to the label for the Mooneten game in the scene.
@onready var mooneten_game: Node = $"mg_back/Mooneten Game Label"

## Reference to the label for the Moonstone game in the scene.
@onready var moonstone_game: Node = $"mg_back/Moonstone Game Label"

## Reference to the label for the currency in the scene.
@onready var currency: Node = $"Currency/Currency Label"

## Reference to the description label in the background of the scene.
@onready var discription: Node = $Background/description

## Reference to the label for the map in the scene.
@onready var map_lable: Node = $Map/Map_label

## Reference to the label for the "press again" hint in the scene.
@onready var press_again: Node = $"press again"


## Called when the node enters the scene tree for the first time.
func _ready():
	_label_visible_false()
	discription.visible = true

## Function to hide specific labeled nodes in the scene.
func _label_visible_false():
	building_pit_label.visible = false
	spaceship_label.visible = false
	shop_label.visible = false
	mooneten_game.visible = false
	moonstone_game.visible = false
	currency.visible = false
	discription.visible = false
	map_lable.visible = false
	press_again.visible = false

## Function called when the space ship is pressed.
## First Set Lable Visible true, if its pressed again, change the current scene
func _on_space_ship_pressed():
	if spaceship_label.visible == false:
		_label_visible_false()
		spaceship_label.visible = true
	else:
		print("Spaceship_Szene")

## Function called when the shop is pressed.
## First Set Lable Visible true, if its pressed again, change the current scene
func _on_shop_pressed():
	if shop_label.visible == false:
		_label_visible_false()
		shop_label.visible = true
		press_again.visible = true
	else:
		var shop_tutorial: Node = load("res://Tutorial/Shop_t/Shop_tutorial.tscn").instantiate()
		get_tree().root.add_child(shop_tutorial)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = shop_tutorial



## Function called when the space ship is pressed.
## First Set Lable Visible true
func _on_touch_screen_button_pressed():
	_label_visible_false()
	discription.visible = true
	
## Function for bulding pits.
## First Set Lable Visible true, if its pressed again, change the current scene
func _building_pit():
	if building_pit_label.visible == false:
		_label_visible_false()
		building_pit_label.visible = true
		press_again.visible = true
	else:
		var building_t: Node = load("res://Tutorial/Buildingpit_t/Buildingpit_t.tscn").instantiate()
		get_tree().root.add_child(building_t)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = building_t

## Function called when a building pit is pressed.
func _on_building_pits_pressed():
	_building_pit()
	
## Function called when a building pit is pressed.
func _on_building_pits_2_pressed():
	_building_pit()
	
## Function called when a building pit is pressed.
func _on_building_pits_3_pressed():
	_building_pit()

## Function called when a building pit is pressed.
func _on_building_pits_4_pressed():
	_building_pit()
	
## Function called when a building pit is pressed.
func _on_building_pits_5_pressed():
	_building_pit()

## Function called when a building pit is pressed.
func _on_building_pits_6_pressed():
	_building_pit()
	
## Function called when a building pit is pressed.
func _on_building_pits_7_pressed():
	_building_pit()

## Function called when the currency is pressed.
## First Set Lable Visible true
func _on_currency_pressed():
	_label_visible_false()
	currency.visible = true

## Function called when minigame 1 is pressed.
## First Set Lable Visible true, if its pressed again, change the current scene
func _on_mg_1_pressed():
	if mooneten_game.visible == false:
		_label_visible_false()
		mooneten_game.visible = true
		press_again.visible = true
	else:
		var minigame1_t: Node = load("res://Tutorial/Minigame1/minigame1_t.tscn").instantiate()
		get_tree().root.add_child(minigame1_t)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = minigame1_t

## Function called when minigame 2 is pressed.
## First Set Lable Visible true, if its pressed again, change the current scene
func _on_mg_2_pressed():
	if moonstone_game.visible == false:
		_label_visible_false()
		moonstone_game.visible = true
		press_again.visible = true
	else:
		var minigame2_t: Node = load("res://Tutorial/Minigame2/minigame2_t.tscn").instantiate()
		get_tree().root.add_child(minigame2_t)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = minigame2_t

## Function called when the map is pressed.
## First Set Lable Visible true, if its pressed again, change the current scene to main menue
func _on_map_released():
	if map_lable.visible == false:
		_label_visible_false()
		map_lable.visible = true
	else:
		var start_m: Node = load("res://Start_Menue/Scene/start_menue.tscn").instantiate()
		get_tree().root.add_child(start_m)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = start_m
