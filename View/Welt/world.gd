# This script extends the Node2D class
# This script handles behavior and interactions for a 2D node in the game.

extends Node2D

@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player.position = DataScript.get_last_player_position()
	y_sort_enabled = true
	get_tree().set_auto_accept_quit(false)
	

# Notification function called for window management events
func _notification(what):
	# Handle a close request from the window manager
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		DataScript.setUnixLastTime(Time.get_unix_time_from_system())
		DataScript.set_last_player_position(player.position)
		get_tree().quit()
	# Handle a go back request from the window manager
	elif what == NOTIFICATION_WM_GO_BACK_REQUEST:
		DataScript.setUnixLastTime(Time.get_unix_time_from_system())
		DataScript.set_last_player_position(player.position)
		get_tree().quit()
