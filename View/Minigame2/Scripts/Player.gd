extends CharacterBody2D

# Constants: FIRST_LANE, LAST_LANE, LANE_LENGTH
# Description: Defines the lane borders and length.
# - SCORE_TO_MOONETEN_FACTOR: A Factor for converting the Score to Moonstone
const FIRST_LANE = 64
const LAST_LANE = 256
const LANE_LENGTH = 64
const SCORE_TO_MOONETEN_FACTOR: float = 0.01

# Variables: gameover_screen, overlay_score, overlay_pause_button, score_label, highscore_label
# Description: Hold references to UI elements in the game.
# - gameover_screen: Reference to the game over screen.
# - overlay_score: Reference to the label displaying the current score in the overlay.
# - overlay_pause_button: Reference to the touchscreen button for pausing the game in the overlay.
# - score_label: Onready reference to the label displaying the score in the game.
# - highscore_label: Onready reference to the label displaying the high score in the game.
var gameover_screen: Control
var overlay_score: Label
var overlay_pause_button: TouchScreenButton
@onready var score_label: Label
@onready var highscore_label: Label


# Function: _ready
# Description: Called when the node enters the scene tree for the first time.
# Initializes player position, game over screen, score label, highscore label, overlay score, and overlay pause button.
# Called when the node enters the scene tree for the first time.
func _ready():
	init_player()
	initialize_ui_references()


# Function: init_player
# Description: Initializes the Player Startposition.
func init_player():
	global_position.x = FIRST_LANE
	global_position.y = get_viewport_rect().size.y - 20


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	player_movement()


# Function: initialize_ui_references
# Description: Initializes UI references when the node enters the scene tree.
func initialize_ui_references():
	gameover_screen = get_parent().get_node("Hud/GameOverScreen")
	score_label = gameover_screen.get_node("scoreLabel")
	highscore_label = gameover_screen.get_node("highscoreLabel")
	overlay_score = get_parent().get_node("Hud/Overlay/Score")
	overlay_pause_button = get_parent().get_node("Hud/Overlay/PauseButton")


# Function: player_movement
# Description: Manages player movement based on user input.
# Moves the player left if the left arrow key is pressed (not in the first lane),
# moves the player right if the right arrow key is pressed (not in the last lane),
# and utilizes Godot's move_and_slide function for continuous movement.
func player_movement():
	move_player("ui_left", -LANE_LENGTH)
	move_player("ui_right", LANE_LENGTH)


# Function: move_player
# Description: Moves the player based on user input and lane boundaries.
func move_player(action, delta_x):
	if Input.is_action_just_pressed(action) and is_within_lane_bounds(delta_x):
		global_position.x += delta_x


# Function: is_within_lane_bounds
# Description: Checks if the player is within the first and last lane boundaries.
func is_within_lane_bounds(delta_x):
	return FIRST_LANE <= global_position.x + delta_x && global_position.x + delta_x <= LAST_LANE


# Function: _on_area_2d_area_entered
# Description: Called when the Player node detects another area entering it.
# Sets the high score to the current score, updates UI labels, pauses the game, and shows the game over screen.
func _on_area_2d_area_entered(_area):
	update_high_score()
	update_ui_labels()
	add_moonstone_to_storage()
	end_game()


# Function: update_high_score
# Description: Sets the high score to the current score.
func update_high_score():
	DataScript.set_minigame2_highscore(DataScript.get_minigame2_score())
	highscore_label.text = "Highscore: " + str(DataScript.get_minigame2_highscore())


# Function: update_ui_labels
# Description: Updates UI labels with current score information.
func update_ui_labels():
	score_label.text = "Score: " + str(DataScript.get_minigame2_score())


# Function: end_game
# Description: Pauses the game, hides overlay elements, and shows the game over screen.
func end_game():
	get_tree().paused = true
	overlay_score.visible = false
	overlay_pause_button.visible = false
	gameover_screen.visible = true


# Function: _score2Moonstone
# Description: Adds the product of Minigame2 score and a specified factor to the Moonstone resource, ensuring it does not exceed the maximum storage limit.
func add_moonstone_to_storage():
	# Add Score * Factor to Comet.
	if (
		(DataScript.get_moonstone() + DataScript.get_minigame2_score() * SCORE_TO_MOONETEN_FACTOR)
		<= DataScript.maxMoonstoneStorage
	):
		DataScript.add_moonstone(DataScript.get_minigame2_score() * SCORE_TO_MOONETEN_FACTOR)
