## This script handles the interaction with a touch screen button to toggle visibility of a building placement UI.

extends Node2D

# Nodes for building placement UI
## Reference to the node representing the building placement interface.
@onready var building_inv: Node = $"GebäudePlazieren"
## Reference to the node representing the text associated with the building placement interface.
@onready var building_text: Node = $inv_text

# Function: _on_touch_screen_button_pressed
## Called when the screen is pressed. Toggles the visibility of the building placement UI and associated text.
## If the UI is not visible, it sets it to visible along with the text. If pressed again, it changes the current scene
## back to the main tutorial.
func _on_touch_screen_button_pressed():
	if building_inv.visible == false:
		building_inv.visible = true
		building_text.visible = true
	else:
		var main_T: Node = load("res://Tutorial/Tutorial_1.tscn").instantiate()
		get_tree().root.add_child(main_T)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = main_T
