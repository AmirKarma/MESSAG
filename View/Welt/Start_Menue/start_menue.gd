extends Control


# Function: _ready
# Description: Disables the "Fortsetzen" button if it is the first time playing.
func _ready():
	if(DataScript.isPlayingFirstTime()):
		$VBoxContainer/Buttons/Fortsetzen.disabled = true


# Function: _on_fortsetzen_pressed
# Description: Initiates the main game scene if it is not the first time playing.
func _on_fortsetzen_pressed():
	if !DataScript.isPlayingFirstTime():
		get_tree().change_scene_to_file("res://Welt/world.tscn")


# Function: _on_neues_spiel_pressed
# Description: Displays the confirmation dialog if it is not the first game; otherwise, starts a new game.
func _on_neues_spiel_pressed():
	if !DataScript.firstGame:
		$ConfirmationDialog.visible = true
	else:
		newGame()


# Function: _on_impressum_pressed
# Description: Loads and instantiates the impressum scene, adds it to the tree, and replaces the current scene with impressum.
func _on_impressum_pressed():
	get_tree().change_scene_to_file("res://Welt/Start_Menue/imprint/impressum.tscn")


# Function: _on_confirmation_dialog_confirmed
# Description: Initiates a new game when the confirmation dialog is confirmed.
func _on_confirmation_dialog_confirmed():
	newGame()


# Function: newGame
# Description: Starts a new game by resetting stats, loading and instantiating the main game scene, and replacing the current scene with the main game.
func newGame():
	DataScript.resetStats()
	get_tree().change_scene_to_file("res://Welt/world.tscn")
	DataScript.setFirstGame(false)
	DataScript.updateStorageBuildingCapacity()
