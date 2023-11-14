extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	y_sort_enabled = true
	
func _process(_delta):
		if Input.is_action_just_pressed("debug"):
			var minigame = load("res://Minigame1/minigame_1.tscn").instantiate()
			get_tree().root.add_child(minigame)
			get_tree().current_scene.queue_free()
			get_tree().current_scene = minigame
