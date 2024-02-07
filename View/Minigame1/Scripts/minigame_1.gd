## This script manages the gameplay mechanics and UI interactions for Minigame 1.


extends Node2D

## Exported variable for score, connecting it to the UI
@export var score: float = 0:
	set(points):
		score = points
		score_display.points = score

## Reference to the game over screen in the scene.
var gameover_screen: Control

## Reference to the overlay score element in the scene.
var overlay_score: Control

## Reference to the touchscreen button for pausing the game in the overlay.
var overlay_pause_button: TouchScreenButton

## Reference to the touchscreen button for shooting in the overlay.
var overlay_touchshot: TouchScreenButton

## Reference to the joystick node in the scene.
var joystick: Node2D

## Timer node for controlling comet spawning.
var comet_spawn_timer: Timer

## Time interval for comet spawning.
var spawn_time: float = 10

## Factor for converting comet destruction to score points.
var score_to_comet_factor: float = 0.1

## Preloaded scene for comets.
var comet_scene: PackedScene = preload("res://Minigame1/Scenes/comet.tscn")


## Reference to the marker for player spawn position in the scene.
@onready var player_spawn_pos: Marker2D = $startPos

## Reference to the node containing all the shots fired by the player.
@onready var shot_container: Node2D = $shootCont

## Reference to the cannon node in the scene.
@onready var cannon: Node = $Gun

## Reference to the spaceship node in the scene.
@onready var player: spaceship = $spaceship

## Reference to the node containing all comets in the scene.
@onready var comets: Node = $AllComets

## Reference to the control displaying the score in the scene.
@onready var score_display: Control = $Points/info

## Reference to the control displaying the remaining lives in the scene.
@onready var lives_display: Control = $Points/info

## Reference to the node representing the respawn position in the scene.
@onready var respawn_position: Node2D = $RespawnPos

## Reference to the label displaying the current score in the scene.
@onready var score_label: Label

## Reference to the label displaying the high score in the scene.
@onready var highscore_label: Label


## Initializes various aspects of minigame 1 upon entering the scene tree.
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

## Function called when the player shoots
## Adds a shot fired by the player to the cannon.
func _player_shoot(shot):
	cannon.add_child(shot)

## Process function called every frame
## Handles debug and reset input actions.
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

## Function called when the player dies
## Decreases the player's lives count and handles game over conditions.
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

## Function called when a comet is destroyed
## Updates the score and spawns new comets based on the destroyed comet's size.
func _comet_destroyed(com_position, size, points):
	score += points
	for i in range(2):
		match size:
			Comet.CometSize.LARGE:
				spawn_comet(com_position, Comet.CometSize.MEDIUM)
			Comet.CometSize.MEDIUM:
				spawn_comet(com_position, Comet.CometSize.SMALL)
			Comet.CometSize.SMALL:
				pass

# Function: initialize_ui_references
## Initializes UI references when the node enters the scene tree.
## Sets up references to various UI elements such as score labels, game over screen, buttons, and joystick.
func initialize_ui_references():
	gameover_screen = get_node("Points/GameOverScreen")
	score_label = gameover_screen.get_node("scoreLabel")
	highscore_label = gameover_screen.get_node("highscoreLabel")
	overlay_score = get_node("Points/info")
	overlay_pause_button = get_node("Points/PauseButton")
	overlay_touchshot = get_node("Points/Touchshot")
	joystick = get_node("Joystick")

# Function: update_high_score
## Updates the high score displayed on the UI.
func update_high_score():
	highscore_label.text = "Highscore: " + str(DataScript.get_minigame1_highscore())

# Function: update_score
## Updates the current score displayed on the UI.
func update_score():
	score_label.text = "Score: " + str(DataScript.get_minigame1_score())		


## Sets up a variable for player lives and updates the UI element accordingly.
var lives: int = 3:
	set(value):
		lives = value
		lives_display.lives = lives

# Function: set_game_over_screen
## Displays the game over screen and disables other UI elements.
func set_game_over_screen():
	update_score()
	update_high_score()
	get_tree().paused = true
	joystick.visible = false
	overlay_touchshot.visible = false
	overlay_score.visible = false
	overlay_pause_button.visible = false
	gameover_screen.visible = true


## Instantiates a comet scene at a specified position and size.
func spawn_comet(spawn_position, size):
	var comet: Comet = comet_scene.instantiate()
	comet.global_position = spawn_position
	comet.size = size
	comet.connect("destroyed", _comet_destroyed)
	comets.call_deferred("add_child", comet)


## Spawns a new comet periodically based on a timer.
func new_comet():
	var comet: Comet = comet_scene.instantiate()
	comet.connect("destroyed", _comet_destroyed)
	#comets.call_deferred("add_child", comet)
	comets.add_child(comet)
	spawn_time = spawn_time * 0.9
	comet_spawn_timer.start()
