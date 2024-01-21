# GameWorld script

extends Node2D

# References to scene elements using the @onready keyword
@onready var player_spawn_pos: Marker2D = $startPos
@onready var shot_container: Node2D = $shootCont
@onready var cannon: Node = $Gun
@onready var player: spaceship = $spaceship
@onready var comets: Node = $AllComets
@onready var score_display: Control = $Points/info
@onready var lives_display: Control = $Points/info
@onready var respawn_position: Node2D = $RespawnPos

# Variables: gameover_screen, overlay_score, overlay_pause_button, score_label, highscore_label
# Description: Hold references to UI elements in the game.
# - gameover_screen: Reference to the game over screen.
# - overlay_score: Reference to the label displaying the current score in the overlay.
# - overlay_pause_button: Reference to the touchscreen button for pausing the game in the overlay.
# - score_label: Onready reference to the label displaying the score in the game.
# - highscore_label: Onready reference to the label displaying the high score in the game.
# - overlay_touchshot: Reference to the shoot button
# - joystick: Reference to the joystick
var gameover_screen: Control
var overlay_score: Control
var overlay_pause_button: TouchScreenButton
var overlay_touchshot: TouchScreenButton
var joystick: Node2D
@onready var score_label: Label
@onready var highscore_label: Label

# Timer variable for comet spawning
var comet_spawn_timer: Timer
var spawn_time: float = 10

# Factor for Score to add on Comet destruction
var score_to_comet_factor: float = 0.1

# Exported variable for score, connecting it to the UI
@export var score: float = 0:
	set(points):
		score = points
		score_display.points = score

# Preload the comet scene for instantiation
var comet_scene: PackedScene = preload("res://Minigame1/Scenes/comet.tscn")


func _ready():
	initialize_ui_references()
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

	for i in range(2):
		new_comet()


# Function: initialize_ui_references
# Description: Initializes UI references when the node enters the scene tree.
func initialize_ui_references():
	gameover_screen = get_node("Points/GameOverScreen")
	score_label = gameover_screen.get_node("scoreLabel")
	highscore_label = gameover_screen.get_node("highscoreLabel")
	overlay_score = get_node("Points/info")
	overlay_pause_button = get_node("Points/PauseButton")
	overlay_touchshot = get_node("Points/Touchshot")
	joystick = get_node("Joystick")


# Process function called every frame
func _process(_delta):
	# Check for debug input to return to the main game
	if Input.is_action_just_pressed("debug"):
		var maingame: Node = load("res://Welt/world.tscn").instantiate()
		get_tree().root.add_child(maingame)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = maingame

	# Check for reset input to reload the current scene
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


# Function: update_high_score
# Description: Sets the high score to the current score.
func update_high_score():
	highscore_label.text = "Highscore: " + str(DataScript.get_minigame1_highscore())


# Function: update_score
# Description: Updates the current score.
func update_score():
	score_label.text = "Score: " + str(DataScript.get_minigame1_score())


# Variable for player lives, connecting it to the UI
var lives: int = 3:
	set(value):
		lives = value
		lives_display.lives = lives


# Function called when the player dies
func _player_dies():
	lives -= 1

	# Check if no lives left
	if lives <= 0:
		# Save the score and transition to the game over screen
		DataScript.set_minigame1_score(score)
		# Add Score * Factor to Comet.
		if (
			(DataScript.get_mooneten() + score * score_to_comet_factor)
			<= DataScript.maxMoonetenStorage
		):
			DataScript.add_mooneten(score * score_to_comet_factor)
		else:
			DataScript.set_mooneten(DataScript.maxMoonetenStorage)
		set_game_over_screen()
	else:
		# Respawn the player after a delay
		await get_tree().create_timer(1).timeout
		player.respawn(respawn_position.global_position)


# Function: set_game_over_screen
# Description: Makes the Gameoverscreen visiable and all other Gui elements will be disabled
func set_game_over_screen():
	update_score()
	update_high_score()
	get_tree().paused = true
	joystick.visible = false
	overlay_touchshot.visible = false
	overlay_score.visible = false
	overlay_pause_button.visible = false
	gameover_screen.visible = true


# Function called when the player shoots
func _player_shoot(shot):
	cannon.add_child(shot)


# Function called when a comet is destroyed
func _comet_destroyed(com_position, size, points):
	# Update the score and spawn new comets based on the destroyed comet's size
	score += points
	for i in range(2):
		match size:
			Comet.CometSize.LARGE:
				spawn_comet(com_position, Comet.CometSize.MEDIUM)
			Comet.CometSize.MEDIUM:
				spawn_comet(com_position, Comet.CometSize.SMALL)
			Comet.CometSize.SMALL:
				pass


# Function to spawn a comet at a given position and size
func spawn_comet(spawn_position, size):
	var comet: Comet = comet_scene.instantiate()
	comet.global_position = spawn_position
	comet.size = size
	comet.connect("destroyed", _comet_destroyed)
	comets.call_deferred("add_child", comet)


# Function to spawn a new comet periodically using the timer
func new_comet():
	var comet: Comet = comet_scene.instantiate()
	comet.connect("destroyed", _comet_destroyed)
	#comets.call_deferred("add_child", comet)
	comets.add_child(comet)
	spawn_time = spawn_time * 0.9
	comet_spawn_timer.start()
