extends Control

# Function: _on_touch_screen_button_pressed
# Description: Called when the touch screen button is pressed. Loads and instantiates the start menu scene, replaces the current scene with the start menu.
func _on_touch_screen_button_pressed():
	var start_menu = load("res://Welt/Start_Menue/start_menue.tscn").instantiate()
	get_tree().root.add_child(start_menu)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = start_menu
