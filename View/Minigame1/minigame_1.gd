extends Node2D

@onready var spieler_spawn_pos = $StartPosition
@onready var schuss_container = $SchussContainer
@onready var Kanone = $Kanone
@onready var raumschiff = $Raumschiff
@onready var kometen = $AllKometen
@onready var Punkte = $Punkte/info
@onready var RespawnPos = $RespawnPos


var lives := 2


var score := 0:
	set(value):
		score = value
		Punkte.punkte = score

var kometen_scene = preload("res://Minigame1/kometen.tscn")

func _ready():
	score = 0
	
	raumschiff.connect("kanonen_schuss", _spieler_kanonen_schuss)
	raumschiff.connect("spieler_tot", _spieler_stirbt)
	
	for Kometen in kometen.get_children():
		Kometen.connect("zerstört", _kometen_zerstört)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("debug"):
		var maingame = load("res://Welt/world.tscn").instantiate()
		get_tree().root.add_child(maingame)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = maingame

	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
		
		
func _spieler_stirbt(schuss):
	lives -= 1
	if lives <= 0:
		get_tree().reload_current_scene()
	else:
		await get_tree().create_timer(1).timeout
		raumschiff.respawn(RespawnPos.global_position)
		
		
		
		
func _spieler_kanonen_schuss(schuss):
	Kanone.add_child(schuss)

func _kometen_zerstört(position,size,punkte):
	score += punkte
	for i in range(2):
		match size:
			Kometen.KometenGroesse.GROSS:
				spawn_kometen(position, Kometen.KometenGroesse.MITTEL)
			Kometen.KometenGroesse.MITTEL:
				spawn_kometen(position, Kometen.KometenGroesse.KLEIN)
			Kometen.KometenGroesse.KLEIN:
				pass
	print(score)
			

func spawn_kometen(position, size):
	var k = kometen_scene.instantiate()
	k.global_position = position
	k.size = size
	k.connect("zerstört", _kometen_zerstört)
	kometen.call_deferred("add_child",k)
	
