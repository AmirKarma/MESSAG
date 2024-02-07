## It defines the behavior for the button press event, changing the scene to "minigame_1.tscn" and resuming the game.

extends Button


## Function called when the button is pressed
func _pressed():
	# Change the scene to the specified file
	get_tree().change_scene_to_file("res://Minigame1/Scenes/minigame_1.tscn")
	get_tree().paused = false
