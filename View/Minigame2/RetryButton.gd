extends Button

func _pressed():
	get_tree().change_scene_to_file("res://Minigame2/minigame2.tscn")
	get_tree().paused = false
