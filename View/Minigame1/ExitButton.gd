extends Button

# Function called when the button is pressed
func _pressed():
	# Change the scene to the specified file
	get_tree().change_scene_to_file("res://Welt/world.tscn")
	get_tree().paused = false
