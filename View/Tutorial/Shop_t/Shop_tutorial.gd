## This script defines a Node2D that handles the functionality to return to the main tutorial scene when a screen press event occurs.

extends Node2D


## Function called when the screen is pressed.
## It changes the current scene back to main tutorial
func _on_back_2_tutorial_pressed():
	var main_tutorial: Node = load("res://Tutorial/Tutorial_1.tscn").instantiate()
	get_tree().root.add_child(main_tutorial)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = main_tutorial
