extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	if(DataScript.isPlayingFirstTime()):
		$VBoxContainer/Fortsetzen.disabled = true


func _on_fortsetzen_pressed():
	if(!DataScript.isPlayingFirstTime()):
		var maingame = load("res://Welt/world.tscn").instantiate()
		get_tree().root.add_child(maingame)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = maingame


func _on_neues_spiel_pressed():
	#if !DataScript.firstGame:
	#	$ConfirmationDialog.visible = true
	#else:
	newGame()

	


func _on_impressum_pressed():
	var impressum = load("res://Welt/Start_Menue/impressum.tscn").instantiate()
	get_tree().root.add_child(impressum)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = impressum


func _on_confirmation_dialog_confirmed():
	newGame()

func newGame():
	DataScript.resetStats()
	var maingame = load("res://Welt/world.tscn").instantiate()
	get_tree().root.add_child(maingame)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = maingame
	DataScript.setFirstGame(false)
