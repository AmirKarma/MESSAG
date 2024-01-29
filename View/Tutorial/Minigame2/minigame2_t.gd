extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Function called when the screen is pressed.
# change the current scene back to main tutorial
func _on_touch_screen_button_pressed():
	var tutorial1: Node = load("res://Tutorial/Tutorial_1.tscn").instantiate()
	get_tree().root.add_child(tutorial1)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = tutorial1
