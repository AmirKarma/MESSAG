extends Button

# Function: _pressed
# Description: Handles the logic when a button or input is pressed.
# Changes the scene to "minigame2.tscn" and resumes the game.
func _pressed():
	get_tree().change_scene_to_file("res://Minigame2/minigame2.tscn")
	get_tree().paused = false

