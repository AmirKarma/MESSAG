extends Node2D

@onready var spieler_spawn_pos = $StartPosition
@onready var schuss_container = $SchussContainer
@onready var Kanone = $Kanone
@onready var spieler = $Spieler



# Called when the node enters the scene tree for the first time.
func _ready():
	spieler.connect("kanonen_schuss", _spieler_kanonen_schuss)
	


func _process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	elif Input.is_action_just_pressed("minigame1"):
		var maingame_scene = preload("res://Welt/world.tscn").instantiate()
		get_tree().root.add_child(maingame_scene)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = maingame_scene

	
func _spieler_kanonen_schuss(schuss):
	Kanone.add_child(schuss)
