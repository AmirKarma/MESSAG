extends Node2D

# References to scene elements using the @onready keyword
@onready var spieler_spawn_pos = $StartPosition
@onready var schuss_container = $SchussContainer
@onready var Kanone = $Kanone
@onready var raumschiff = $Raumschiff
@onready var kometen = $AllKometen
@onready var Punkte = $Punkte/info
@onready var Leben = $Punkte/info
@onready var RespawnPos = $RespawnPos

# Timer variable for comet spawning
var timer2


# Exported variable for score, connecting it to the UI
@export var score := 0:
	set(punkte):
		score = punkte
		Punkte.punkte = score

# Preload the comet scene for instantiation
var kometen_scene = preload("res://Minigame1/kometen.tscn")

func _ready():
	
	# Initialize score and lives
	score = 0
	lives = 3

	# Set up and start the timer for comet spawning
	timer2 = Timer.new()
	add_child(timer2)
	timer2.wait_time = 5
	timer2.timeout.connect(new_kometen)
	timer2.start()
	
	# Connect signals for player events
	raumschiff.connect("kanonen_schuss", _spieler_kanonen_schuss)
	raumschiff.connect("spieler_tot", _spieler_stirbt)
	
	# Connect signals for comet destruction
	for Kometen in kometen.get_children():
		Kometen.connect("zerstört", _kometen_zerstört)
		
# Process function called every frame
func _process(delta):
	# Check for debug input to return to the main game
	if Input.is_action_just_pressed("debug"):
		var maingame = load("res://Welt/world.tscn").instantiate()
		get_tree().root.add_child(maingame)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = maingame

	# Check for reset input to reload the current scene
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
	
		
# Variable for player lives, connecting it to the UI
var lives := 3:
	set(value):
		lives = value
		Leben.leben = lives
		
# Function called when the player dies
func _spieler_stirbt():
	lives -= 1
	
	# Check if no lives left
	if lives <= 0:
		# Save the score and transition to the game over screen
		DataScript.setM1Score(score)
		var maingame = load("res://Minigame1/GameOverScreen.tscn").instantiate()
		get_tree().root.add_child(maingame)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = maingame
		DataScript.addMooneten(score)
		
	else:
		# Respawn the player after a delay
		await get_tree().create_timer(1).timeout
		raumschiff.respawn(RespawnPos.global_position)
		
		
		
# Function called when the player shoots
func _spieler_kanonen_schuss(schuss):
	Kanone.add_child(schuss)
	
# Function called when a comet is destroyed
func _kometen_zerstört(position,size,punkte):
	# Update the score and spawn new comets based on the destroyed comet's size
	score += punkte
	for i in range(2):
		match size:
			Kometen.KometenGroesse.GROSS:
				spawn_kometen(position, Kometen.KometenGroesse.MITTEL)
			Kometen.KometenGroesse.MITTEL:
				spawn_kometen(position, Kometen.KometenGroesse.KLEIN)
			Kometen.KometenGroesse.KLEIN:
				pass
			
# Function to spawn a comet at a given position and size
func spawn_kometen(position, size):
	var k = kometen_scene.instantiate()
	k.global_position = position
	k.size = size
	k.connect("zerstört", _kometen_zerstört)
	kometen.call_deferred("add_child",k)

# Function to spawn a new comet periodically using the timer
func new_kometen():
	var k = kometen_scene.instantiate()
	k.connect("zerstört", _kometen_zerstört)
	kometen.call_deferred("add_child",k)
	add_child(k)
	timer2.start()
	
