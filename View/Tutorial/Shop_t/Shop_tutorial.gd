extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_2_tutorial_pressed():
	var main_tutorial: Node = load("res://Tutorial/Tutorial_1.tscn").instantiate()
	get_tree().root.add_child(main_tutorial)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = main_tutorial
