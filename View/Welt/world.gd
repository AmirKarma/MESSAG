# This script extends the Node2D class
# This script handles behavior and interactions for a 2D node in the game.

extends Node2D

# Variable for the player node
@onready var player: CharacterBody2D = $Player


# Function: _ready
# Description: Initializes the player's position and enables y-sorting.
# 			   Disables auto-accept quit for custom handling.
func _ready():
	player.position = DataScript.get_last_player_position()
	y_sort_enabled = true
	get_tree().set_auto_accept_quit(false)


# Function: _notification
# Description: Handles notifications from the window manager, specifically close and go back requests.
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
