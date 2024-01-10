extends Button

# Function: _pressed
# Description: Handles the logic when a button or input is pressed.
# This function changes the scene to "world.tscn" located in the "Welt" directory
# and resumes the game by unpausing the game tree.

func _pressed():
	# Change the scene to "world.tscn" in the "Welt" directory
	get_tree().change_scene_to_file("res://Welt/world.tscn")
	
	# Resume the game by setting the game tree's paused state to false
	get_tree().paused = false
