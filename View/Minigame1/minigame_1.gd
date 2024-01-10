# GameWorld script

extends Node2D

# References to scene elements using the @onready keyword
@onready var player_spawn_pos = $startPos
@onready var shot_container = $shootCont
@onready var cannon = $Gun
@onready var player = $spaceship
@onready var comets = $AllComets
@onready var score_display = $Points/info
@onready var lives_display = $Points/info
@onready var respawn_position = $RespawnPos

# Timer variable for comet spawning
var comet_spawn_timer
var spawn_time := 10

# Factor for Score to add on Comet destruction
var score_to_comet_factor := 0.1

# Exported variable for score, connecting it to the UI
@export var score := 0:
	set(points):
		score = points
		score_display.points = score

# Preload the comet scene for instantiation
var comet_scene = preload("res://Minigame1/comet.tscn")

func _ready():
	# Initialize score and lives
	score = 0
	lives = 3

	# Set up and start the timer for comet spawning
	comet_spawn_timer = Timer.new()
	add_child(comet_spawn_timer)
	comet_spawn_timer.wait_time = spawn_time
	comet_spawn_timer.timeout.connect(new_comet)
	comet_spawn_timer.start()

	# Connect signals for player events
	player.connect("cannon_shot", _player_shoot)
	player.connect("player_dead", _player_dies)

	# Connect signals for comet destruction
	for comet in comets.get_children():
		comet.connect("destroyed", _comet_destroyed)

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
		lives_display.lives = lives

# Function called when the player dies
func _player_dies():
	lives -= 1

	# Check if no lives left
	if lives <= 0:
		# Save the score and transition to the game over screen
		DataScript.setM1Score(score)
		var maingame = load("res://Minigame1/GameOverScreen.tscn").instantiate()
		get_tree().root.add_child(maingame)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = maingame
		# Add Score * Factor to Comet. 
		if (DataScript.getMooneten() + score * score_to_comet_factor) <= DataScript.maxMoonetenStorage:
			DataScript.addMooneten(score * score_to_comet_factor)
		else:
			DataScript.setMooneten(DataScript.maxMoonetenStorage)
	else:
		# Respawn the player after a delay
		await get_tree().create_timer(1).timeout
		player.respawn(respawn_position.global_position)

# Function called when the player shoots
func _player_shoot(shot):
	cannon.add_child(shot)

# Function called when a comet is destroyed
func _comet_destroyed(position, size, points):
	# Update the score and spawn new comets based on the destroyed comet's size
	score += points
	for i in range(2):
		match size:
			Comet.CometSize.LARGE:
				spawn_comet(position, Comet.CometSize.MEDIUM)
			Comet.CometSize.MEDIUM:
				spawn_comet(position, Comet.CometSize.SMALL)
			Comet.CometSize.SMALL:
				pass

# Function to spawn a comet at a given position and size
func spawn_comet(position, size):
	var comet = comet_scene.instantiate()
	comet.global_position = position
	comet.size = size
	comet.connect("destroyed", _comet_destroyed)
	comets.call_deferred("add_child", comet)

# Function to spawn a new comet periodically using the timer
func new_comet():
	var comet = comet_scene.instantiate()
	comet.connect("destroyed", _comet_destroyed)
	comets.call_deferred("add_child", comet)
	add_child(comet)
	spawn_time = spawn_time * 0.9
	comet_spawn_timer.start()
