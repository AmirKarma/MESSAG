extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_touch_screen_button_pressed():
	var start_menu = load("res://Welt/Start_Menue/start_menue.tscn").instantiate()
	get_tree().root.add_child(start_menu)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = start_menu
