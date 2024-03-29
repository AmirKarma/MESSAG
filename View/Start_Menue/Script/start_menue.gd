## This script extends the Control class.
## It handles the behavior and interactions of the start menu UI elements.

extends Control


# Function: _ready
## Disables the "Fortsetzen" button if it is the first time playing.
func _ready():
	if DataScript.is_playing_first_time():
		$VBoxContainer/Buttons/Fortsetzen.disabled = true


# Function: _on_fortsetzen_pressed
## Initiates the main game scene if it is not the first time playing.
func _on_fortsetzen_pressed():
	if !DataScript.is_playing_first_time():
		get_tree().change_scene_to_file("res://World/Scene/world.tscn")


# Function: _on_neues_spiel_pressed
## Displays the confirmation dialog if it is not the first game; otherwise, starts a new game.
func _on_neues_spiel_pressed():
	if !DataScript.firstGame:
		$ConfirmationDialog.visible = true
	else:
		new_game()


# Function: _on_impressum_pressed
## Loads and instantiates the impressum scene, adds it to the tree, and replaces the current scene with impressum.
func _on_impressum_pressed():
	get_tree().change_scene_to_file("res://Start_Menue/imprint/Scenes/Imprint.tscn")


# Function: _on_confirmation_dialog_confirmed
## Initiates a new game when the confirmation dialog is confirmed.
func _on_confirmation_dialog_confirmed():
	new_game()

# Function: _on_button_pressed
## Replacing the current scene with the tutorial screen.
func _on_button_pressed():
	var tutorial: Node = load("res://Tutorial/Tutorial_1.tscn").instantiate()
	get_tree().root.add_child(tutorial)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = tutorial

# Function: new_game
## Starts a new game by resetting stats, loading
## and instantiating the main game scene, and replacing the current scene with the main game.
func new_game():
	DataScript.reset_stats()
	get_tree().change_scene_to_file("res://World/Scene/world.tscn")
	DataScript.set_first_game(false)
	DataScript.update_storage_building_capacity()

