extends Control

# Variables for the nodes
@onready var building_name: Label = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/ScrollContainer/HBoxContainer/Buiding_Card/VBoxContainer/Name
@onready var building_count:Label = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/ScrollContainer/HBoxContainer/Buiding_Card/VBoxContainer/Count
@onready var building_image:AnimatedSprite2D = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/ScrollContainer/HBoxContainer/Buiding_Card/VBoxContainer/HSplitContainer/building_image
@onready var building_card:NinePatchRect = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/ScrollContainer/HBoxContainer/Buiding_Card
@onready var buttons:Control = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/ScrollContainer/HBoxContainer/Buiding_Card/VBoxContainer/button
@onready var place_button:Button = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/ScrollContainer/HBoxContainer/Buiding_Card/VBoxContainer/button/place_button
@onready var empty_lable:Label = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/Empty_lable
@onready var scroll_container:ScrollContainer = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/ScrollContainer

# Constants for building type and building level
const building_type:int = 0
const building_level:int = 2

# Variable to track the current button
var currentButton: Button = null

# Function: _ready
# Description: Calls the set_inventory function when the node enters the scene tree.
func _ready():
	set_inventory()

# Function: set_inventory
# Description: Sets up the inventory by resetting it, making the building card visible,
# and populating it with data from the inventory and shop_data.
func set_inventory():
	reset_inventory()
	building_card.visible = true
	var shop_data = DataScript.shop_data
	if !DataScript.inventory.is_empty():
		for data in DataScript.inventory:
			for building_data in shop_data:
				if building_data['building_id'] == data[building_type]:
					var inventory_index = DataScript.inventory.find(data)
					set_building_data(building_data['building_id'],building_data['name'],data[building_level],inventory_index)
	else: 
		scroll_container.visible = false
		empty_lable.visible = true
	building_card.visible = false

# Function: reset_inventory
# Description: Resets the inventory by making the scroll container visible, hiding the empty label,
# and removing all child nodes from the parent of the building card.
func reset_inventory():
	scroll_container.visible = true
	empty_lable.visible = false
	var parent = building_card.get_parent()
	for child in range(len(parent.get_children()) - 1,1,-1):
		parent.remove_child(parent.get_child(child))

# Function: set_building_data
# Description: Sets the building data by updating the building name, button, level, image,
# and adding a duplicated building card as a sibling.
func set_building_data(building_id:int,buidling_name: String,level:int,inventory_index:int):
	set_buidling_name(buidling_name)
	set_building_button(inventory_index)
	set_building_level(level)
	set_building_image(building_id)
	building_card.add_sibling(building_card.duplicate())

# Function: set_building_name
# Description: Sets the building name text.
func set_buidling_name(buidling_name:String):
	building_name.text = buidling_name

# Function: count_buildings
# Description: Counts the number of buildings with the specified building_id in the inventory.
func count_buildings(building_id:int)-> int:
	var count:int = 0
	for building in DataScript.inventory:
		if building[building_type] == building_id:
			count += 1
	return count

# Function: set_building_level
# Description: Sets the building level text based on the provided count.
func set_building_level(count:int):
	building_count.text = "Lv "+str(count)

# Function: set_building_image
# Description: Sets the building image animation based on the provided building_id.
func set_building_image(building_id:int):
	match(building_id):
		DataScript.moonetenGenerator:
				building_image.play("moonetenGenerator")
		DataScript.moonstoneGenerator:
				building_image.play("moonstoneGenerator")
		DataScript.moonetenStorage:
				building_image.play("moonetenStorage")
		DataScript.moonstoneStorage:
				building_image.play("moonstoneStorage")


func set_building_button(inventory_index:int):
	if currentButton != null:
		buttons.remove_child(currentButton)
		
	var button: Button = place_button.duplicate()
	button.name = str(inventory_index)
	button.visible = true

	buttons.add_child(button)
	currentButton = button

# Function: _on_close_button_pressed
# Description: Handles the event when the close button is pressed.
# Hides the container.
func _on_close_button_pressed():
	visible = false
