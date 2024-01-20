extends Node2D

# ID of the building
var id: int = 12

# Nodes for the scene
@onready var buildings: Node2D = get_node("/root/World/buildings")
@onready var icon: AnimatedSprite2D = $icon
@onready var mooneten_generator_button: Button = $MoonetenGeneratorButton
@onready var moonstone_generator_button: Button = $MoonstoneGeneratorButton
@onready var mooneten_storage_button: Button = $MoonetenStorageButton
@onready var moonstone_storage_button: Button = $MoonstoneStorageButton

# Variable holdes the value of pressed
var pressed: bool = false


# Function: _ready
# Description: Called when the node is ready. Sets the visibility of the node to false.
func _ready():
	self.visible = false


# Function: _process
# Description: Called every frame. Updates buildings and checks building distances.
func _process(_delta):
	buildings.updateBuildings(self)
	buildings.building_distance(self)


# Function: _on_mooneten_generator_button_pressed
# Description: Called when the Mooneten Generator button is pressed. Sets the 'pressed' variable to true.
func _on_mooneten_generator_button_pressed():
	pressed = true


# Function: _on_mooneten_storage_button_pressed
# Description: Called when the Mooneten Storage button is pressed. Sets the 'pressed' variable to true.
func _on_mooneten_storage_button_pressed():
	pressed = true


# Function: _on_moonstone_generator_button_pressed
# Description: Called when the Moonstone Generator button is pressed. Sets the 'pressed' variable to true.
func _on_moonstone_generator_button_pressed():
	pressed = true


# Function: _on_moonstone_storage_button_pressed
# Description: Called when the Moonstone Storage button is pressed. Sets the 'pressed' variable to true.
func _on_moonstone_storage_button_pressed():
	pressed = true
