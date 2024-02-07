## This script defines a control node for managing a building inventory system. It includes various variables and functions for handling building data, user interaction, and inventory management.

extends Control

## Constant representing the type of a building.
const building_type: int = 0

## Constant representing the level of a building.
const building_level: int = 2


## Variable used to track the currently selected button for interaction.
var currentButton: Button = null

## Represents the Label node that displays the name of a building.
@onready
var building_name: Label = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/ScrollContainer/HBoxContainer/Buiding_Card/VBoxContainer/Name

## Represents the Label node that displays the count or quantity of a building.
@onready
var building_count: Label = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/ScrollContainer/HBoxContainer/Buiding_Card/VBoxContainer/Count

## Represents the AnimatedSprite2D node that displays the image or icon of a building.
@onready
var building_image: AnimatedSprite2D = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/ScrollContainer/HBoxContainer/Buiding_Card/VBoxContainer/HSplitContainer/building_image

## Represents the NinePatchRect node that encapsulates the entire building card or container.
@onready
var building_card: NinePatchRect = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/ScrollContainer/HBoxContainer/Buiding_Card

## Represents the Control node that contains buttons for interacting with a building.
@onready
var buttons: Control = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/ScrollContainer/HBoxContainer/Buiding_Card/VBoxContainer/button

## Represents the Button node specifically designed for placing or building the selected structure.
@onready
var place_button: Button = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/ScrollContainer/HBoxContainer/Buiding_Card/VBoxContainer/button/place_button

## Represents the Label node used to display an empty message when no buildings are available or when the building list is empty.
@onready
var empty_lable: Label = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/Empty_lable

## Represents the ScrollContainer node that contains all the building cards, allowing for scrolling through a list of buildings.
@onready
var scroll_container: ScrollContainer = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/ScrollContainer

## Represents the CharacterBody2D node that corresponds to the player character in the game world.
@onready
var player: CharacterBody2D = get_node("/root/World/Player")


# Function: _ready
## Calls the set_inventory function when the node enters the scene tree.
func _ready():
	set_inventory()


# Function: _on_close_button_pressed
## Handles the event when the close button is pressed.
## Hides the container.
func _on_close_button_pressed():
	DataScript.is_in_building_menu = false
	visible = false
	player.get_node("Camera2D/HUD/RessourceBar").visible = true
	player.get_node("Camera2D/HUD/showMap").visible = true

# Function: set_inventory
## Sets up the inventory by resetting it, making the building card visible,
## and populating it with data from the inventory and shop_data.
func set_inventory():
	reset_inventory()

	building_card.visible = true
	var shop_data: Array = DataScript.shop_data
	if !DataScript.inventory.is_empty():
		for data in DataScript.inventory:
			for building_data in shop_data:
				if building_data["building_id"] == data[building_type]:
					var inventory_index: int = DataScript.inventory.find(data)
					set_building_data(
						building_data["building_id"],
						building_data["name"],
						data[building_level],
						inventory_index
					)
	else:
		scroll_container.visible = false
		empty_lable.visible = true
	building_card.visible = false


# Function: reset_inventory
## Resets the inventory by making the scroll container visible, hiding the empty label,
## and removing all child nodes from the parent of the building card.
func reset_inventory():
	scroll_container.visible = true
	empty_lable.visible = false
	var parent: Node = building_card.get_parent()
	for child in range(len(parent.get_children()) - 1, 1, -1):
		parent.remove_child(parent.get_child(child))


# Function: set_building_data
## Sets the building data by updating the building name, button, level, image,
## and adding a duplicated building card as a sibling.
func set_building_data(building_id: int, buidling_name: String, level: int, inventory_index: int):
	set_buidling_name(buidling_name)
	set_building_button(inventory_index)
	set_building_level(level)
	set_building_image(building_id)
	building_card.add_sibling(building_card.duplicate())


# Function: set_building_name
## Sets the building name text.
func set_buidling_name(buidling_name: String):
	building_name.text = buidling_name

# Function: set_building_level
## Sets the building level text based on the provided count.
func set_building_level(count: int):
	building_count.text = "Lv " + str(count)


# Function: set_building_image
## Sets the building image animation based on the provided building_id.
func set_building_image(building_id: int):
	match building_id:
		DataScript.MOONETEN_GENERATOR:
			building_image.play("moonetenGenerator")
		DataScript.moonstoneGenerator:
			building_image.play("moonstoneGenerator")
		DataScript.moonetenStorage:
			building_image.play("moonetenStorage")
		DataScript.moonstoneStorage:
			building_image.play("moonstoneStorage")

## Set the button for placing a building in the user interface.
func set_building_button(inventory_index: int):
	if currentButton != null:
		buttons.remove_child(currentButton)

	var button: Button = place_button.duplicate()
	button.name = str(inventory_index)
	button.visible = true

	buttons.add_child(button)
	currentButton = button

