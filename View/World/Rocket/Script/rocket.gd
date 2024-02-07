## This script represents a the Rocke node in the game world. It handles the ID of the building, tracks whether it's pressed or not, and contains a reference to the buildings node.

extends Node2D

## ID of the building
const id: int = 0

## Variable holdes the value of pressed
var pressed: bool = false

## Reference for the building node
@onready var buildings: Node2D = get_node("/root/World/buildings")


# Function: _process
## This function is called every frame and invokes the 'building_distance' method of the 'buildings' object.
func _process(_delta):
	buildings.building_distance(self)


# Function: _on_option_button_pressed
## Called when the option button is pressed. Sets the 'pressed' variable to true.
func _on_option_button_pressed():
	pressed = true
