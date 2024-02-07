## This script extends the Node2D class and represents a building entity in the game.
## It manages the visibility of the building node and updates its state based on user interactions.

extends Node2D

# ID of the building
## Stores the ID of the building.
var id: int = 4

# Variable holdes the value of pressed
## Boolean variable indicating whether a button has been pressed.
var pressed: bool = false

# Nodes for the scene
## Reference to the buildings node in the scene.
@onready var buildings: Node2D = get_node("/root/World/buildings")
## Reference to the animated sprite for the building icon.
@onready var icon: AnimatedSprite2D = $icon
## Reference to the button for the Mooneten Generator.
@onready var mooneten_generator_button: Button = $MoonetenGeneratorButton
## Reference to the button for the Moonstone Generator.
@onready var moonstone_generator_button: Button = $MoonstoneGeneratorButton
## Reference to the button for the Mooneten Storage.
@onready var mooneten_storage_button: Button = $MoonetenStorageButton
## Reference to the button for the Moonstone Storage.
@onready var moonstone_storage_button: Button = $MoonstoneStorageButton

# Function: _ready
## Called when the node is ready. Sets the visibility of the node to false.
func _ready():
	self.visible = false

# Function: _process
## Called every frame. Updates buildings and checks building distances.
func _process(_delta):
	buildings.updateBuildings(self)
	buildings.building_distance(self)

# Function: _on_mooneten_generator_button_pressed
## Called when the Mooneten Generator button is pressed. Sets the 'pressed' variable to true.
func _on_mooneten_generator_button_pressed():
	pressed = true

# Function: _on_mooneten_storage_button_pressed
## Called when the Mooneten Storage button is pressed. Sets the 'pressed' variable to true.
func _on_mooneten_storage_button_pressed():
	pressed = true

# Function: _on_moonstone_generator_button_pressed
## Called when the Moonstone Generator button is pressed. Sets the 'pressed' variable to true.
func _on_moonstone_generator_button_pressed():
	pressed = true

# Function: _on_moonstone_storage_button_pressed
## Called when the Moonstone Storage button is pressed. Sets the 'pressed' variable to true.
func _on_moonstone_storage_button_pressed():
	pressed = true
