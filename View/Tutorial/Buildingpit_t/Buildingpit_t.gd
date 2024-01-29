extends Node2D

@onready var building_inv : Node = $"GebäudePlazieren"
@onready var building_text : Node = $inv_text

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Function called when the screen is pressed.
# First Sets a Overlay + Lable Visible true, if its pressed again, change the current scene back
# to main tutorial
func _on_touch_screen_button_pressed():
	if building_inv.visible == false:
		building_inv.visible = true
		building_text.visible = true
	else:
		var main_T: Node = load("res://Tutorial/Tutorial_1.tscn").instantiate()
		get_tree().root.add_child(main_T)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = main_T
