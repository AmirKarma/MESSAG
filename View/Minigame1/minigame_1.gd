extends Node2D

@onready var spieler_spawn_pos = $StartPosition
@onready var schuss_container = $SchussContainer
@onready var Kanone = $Kanone
@onready var raumschiff = $Raumschiff


func _ready():
	raumschiff.connect("kanonen_schuss", _spieler_kanonen_schuss)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("debug"):
		var maingame = load("res://Welt/world.tscn").instantiate()
		get_tree().unload_current_scene()
		get_tree().change_scene_to_packed(maingame)
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
		
func _spieler_kanonen_schuss(schuss):
	Kanone.add_child(schuss)
