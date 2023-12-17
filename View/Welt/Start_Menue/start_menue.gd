extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_fortsetzen_pressed():
	var maingame = load("res://Welt/world.tscn").instantiate()
	get_tree().root.add_child(maingame)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = maingame


func _on_neues_spiel_pressed():
	var maingame = load("res://Welt/world.tscn").instantiate()
	get_tree().root.add_child(maingame)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = maingame
	DataScript.setMooneten(0)
	DataScript.setEnergy(0)
	
	
	
	
	#var file_path = "res://Player/playerData.dat"
	#var file = File.new()
	#if file.open(file_path, File.WRITE) == OK:
	#	file.erase()
	#	file.close()
	#	print("Die Datei wurde gelöscht.")
	#else:
	#	print("Fehler beim Öffnen der Datei.")
	
	


func _on_impressum_pressed():
	
	pass # Replace with function body.
