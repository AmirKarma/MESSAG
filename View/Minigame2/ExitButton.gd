extends Button

func _pressed():
	get_tree().change_scene_to_file("res://Welt/world.tscn")
	get_tree().paused = false
