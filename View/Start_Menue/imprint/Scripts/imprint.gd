## This script extends the Control class and defines the behavior for handling touch screen button presses. It loads and instantiates the start menu scene, replacing the current scene with the start menu.
extends Control


# Function: _on_touch_screen_button_pressed
## Called when the touch screen button is pressed.
## Loads and instantiates the start menu scene,replaces the current scene with the start menu.
func _on_touch_screen_button_pressed():
	var start_menu: Node = load("res://Start_Menue/Scene/start_menue.tscn").instantiate()
	get_tree().root.add_child(start_menu)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = start_menu
