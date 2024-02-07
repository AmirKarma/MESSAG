# It defines the logic for handling the retry-button press event in minigame 2.

extends Button


# Function: _pressed
## Handles the logic when a button or input is pressed.
## Changes the scene to "minigame2.tscn" and resumes the game.
func _pressed():
	get_tree().change_scene_to_file("res://Minigame2/Scenes/minigame2.tscn")
	get_tree().paused = false
