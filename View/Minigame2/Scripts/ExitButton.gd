## It is responsible for changing the scene to "world.tscn" 
## and resuming the game by unpausing the game tree when the button is pressed.
extends Button

# Function: _pressed
## Handles the logic when a button or input is pressed.
## Changes the scene to "world.tscn" located in the "Welt" directory
## and resumes the game by unpausing the game tree.
func _pressed():
	# Change the scene to "world.tscn"
	get_tree().change_scene_to_file("res://World/Scene/world.tscn")

	# Resume the game by setting the game tree's paused state to false
	get_tree().paused = false
