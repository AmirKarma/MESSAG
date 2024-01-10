extends CharacterBody2D

# Constants: FIRST_LANE, LAST_LANE, LANE_LENGTH
# Description: Defines the lane borders.
const FIRST_LANE = 64
const LAST_LANE = 256
const LANE_LENGTH = 64

# Variables: gameoverScreen, overlayScore, overlayPauseButton, scoreLable, highscoreLable
# Description: Hold references to UI elements in the game.
# - gameoverScreen: Reference to the game over screen.
# - overlayScore: Reference to the label displaying the current score in the overlay.
# - overlayPauseButton: Reference to the touchscreen button for pausing the game in the overlay.
# - scoreLable: Onready reference to the label displaying the score in the game.
# - highscoreLable: Onready reference to the label displaying the high score in the game.
var gameoverScreen: Control
var overlayScore: Label
var overlayPauseButton: TouchScreenButton
@onready var scoreLable: Label
@onready var highscoreLable: Label


# Function: _ready
# Description: Called when the node enters the scene tree for the first time.
# Initializes player position, game over screen, score label, highscore label, overlay score, and overlay pause button.
func _ready():
	# Initialize player position at the starting lane and at the bottom of the screen
	global_position.x = FIRST_LANE
	global_position.y = get_viewport_rect().size.y - 20
	
	gameoverScreen = get_parent().get_node("Hud/GameOverScreen2")
	scoreLable = get_parent().get_node("Hud/GameOverScreen2/scoreLable")
	highscoreLable = get_parent().get_node("Hud/GameOverScreen2/highscoreLable")
	overlayScore = get_parent().get_node("Hud/Overlay/Score")
	overlayPauseButton = get_parent().get_node("Hud/Overlay/PauseButton")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Call the player_movement function to handle player movement based on user input
	player_movement()


# Function: player_movement
# Description: Manages player movement based on user input.
# Moves the player left if the left arrow key is pressed (not in the first lane),
# moves the player right if the right arrow key is pressed (not in the last lane),
# and utilizes Godot's move_and_slide function for continuous movement.
func player_movement():
	# Check if the left arrow key is pressed and move the player left if not in the first lane
	if Input.is_action_just_pressed("ui_left") and global_position.x != FIRST_LANE:
		global_position.x -= LANE_LENGTH

	# Check if the right arrow key is pressed and move the player right if not in the last lane
	elif Input.is_action_just_pressed("ui_right") and global_position.x != LAST_LANE:
		global_position.x += LANE_LENGTH

	# Move the player using Godot's built-in move_and_slide function
	move_and_slide()




# Function: _on_area_2d_area_entered
# Description: Called when the Player node detects another area entering it.
# Sets the high score to the current score, updates UI labels, pauses the game, and shows the game over screen.
func _on_area_2d_area_entered(area):
	DataScript.setMinigame2_highscore(DataScript.getMinigame2_score())
	highscoreLable.text = "Highscore: " + str(DataScript.getMinigame2_highscore())
	scoreLable.text = "Score: " + str(DataScript.getMinigame2_score())
	get_tree().paused = true
	overlayScore.visible = false
	overlayPauseButton.visible = false
	gameoverScreen.visible = true


	

