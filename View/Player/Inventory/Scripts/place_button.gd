## This script extends the functionality of a Button node.
## It contains a reference to the player character and handles the logic when the button is pressed,
## invoking the player's place_building method with the button's name converted to an integer parameter.

extends Button

## Reference to the onready node for the player character
@onready var player: CharacterBody2D = get_node("/root/World/Player")


# Function: _on_pressed
## Called when the button is pressed. Calls the player's place_building method.
func _on_pressed():
	player.place_building(int(str(self.name)))
