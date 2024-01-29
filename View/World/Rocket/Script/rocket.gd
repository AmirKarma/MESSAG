extends Node2D

# ID of the building
var id: int = 0

# Node for the scene
@onready var buildings: Node2D = get_node("/root/World/buildings")

# Variable holdes the value of pressed
var pressed: bool = false


# Function: _process
# Description: This function is called every frame and invokes the 'building_distance' method of the 'buildings' object.
func _process(_delta):
	buildings.building_distance(self)


# Function: _on_option_button_pressed
# Description: Called when the option button is pressed. Sets the 'pressed' variable to true.
func _on_option_button_pressed():
	pressed = true
