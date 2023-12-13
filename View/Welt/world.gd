# This script extends the Node2D class
# This script handles behavior and interactions for a 2D node in the game.

extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	y_sort_enabled = true
	get_tree().set_auto_accept_quit(false)
	
# Process function called every frame
func _process(_delta):
		if Input.is_action_just_pressed("debug"):
			var minigame = load("res://Minigame1/minigame_1.tscn").instantiate()
			get_tree().root.add_child(minigame)
			get_tree().current_scene.queue_free()
			get_tree().current_scene = minigame

# Notification function called for window management events
func _notification(what):
	# Handle a close request from the window manager
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		DataScript.setUnixLastTime(Time.get_unix_time_from_system())
		get_tree().quit()
	# Handle a go back request from the window manager
	elif what == NOTIFICATION_WM_GO_BACK_REQUEST:
		DataScript.setUnixLastTime(Time.get_unix_time_from_system())
		get_tree().quit()
