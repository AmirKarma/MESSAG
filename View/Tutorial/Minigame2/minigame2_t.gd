## This script handles the behavior when the screen is pressed, specifically for returning to the main tutorial scene.

extends Node2D

## Function called when the screen is pressed.
## Changes the current scene back to main tutorial
func _on_touch_screen_button_pressed():
	var tutorial1: Node = load("res://Tutorial/Tutorial_1.tscn").instantiate()
	get_tree().root.add_child(tutorial1)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = tutorial1
