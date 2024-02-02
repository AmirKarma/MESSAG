extends Button

# Reference to the onready node for the player character
@onready var player: CharacterBody2D = get_node("/root/World/Player")


# Function: _on_pressed
# Description: Called when the button is pressed. Calls the player's place_building method.
func _on_pressed():
	player.place_building(int(str(self.name)))
