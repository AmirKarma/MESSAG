extends Control

# Function: _ready
# Description: Disables the "Fortsetzen" button if it is the first time playing.
func _ready():
	if(DataScript.isPlayingFirstTime()):
		$VBoxContainer/Fortsetzen.disabled = true

# Function: _on_fortsetzen_pressed
# Description: Initiates the main game scene if it is not the first time playing.
func _on_fortsetzen_pressed():
	if(!DataScript.isPlayingFirstTime()):
		var maingame = load("res://Welt/world.tscn").instantiate()
		get_tree().root.add_child(maingame)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = maingame

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
	var impressum = load("res://Welt/Start_Menue/impressum.tscn").instantiate()
	get_tree().root.add_child(impressum)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = impressum

# Function: _on_confirmation_dialog_confirmed
# Description: Initiates a new game when the confirmation dialog is confirmed.
func _on_confirmation_dialog_confirmed():
	newGame()

# Function: newGame
# Description: Starts a new game by resetting stats, loading and instantiating the main game scene, and replacing the current scene with the main game.
func newGame():
	DataScript.resetStats()
	var maingame = load("res://Welt/world.tscn").instantiate()
	get_tree().root.add_child(maingame)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = maingame
	DataScript.setFirstGame(false)
