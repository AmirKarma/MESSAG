extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	self.y_sort_enabled = true

# Process function is called every frame.
# The parameter "delta" represents the time passed since the last frame.
func _process(_delta):
	if Input.is_action_just_pressed("minigame1"):
		var minigame_scene = preload("res://Welt/minigame_1.tscn").instantiate()
		get_tree().root.add_child(minigame_scene)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = minigame_scene
