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

# Function: _unhandled_input
# Description: Handles unhandled input events.
# Toggles the pause state and updates the game's paused status when the "pause" action is pressed.
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		get_tree().change_scene_to_file("res://Start_Menue/Scene/start_menue.tscn")
