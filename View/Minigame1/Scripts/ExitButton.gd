## This script extends the Button class and defines the behavior for the button press event.

extends Button

## Function called when the button is pressed. Changes the scene to "world.tscn" located in the "World/Scene" directory and resumes the game by unpausing the game tree.
func _pressed():
	# Change the scene to the specified file
	get_tree().change_scene_to_file("res://World//Scene/world.tscn")
	get_tree().paused = false
