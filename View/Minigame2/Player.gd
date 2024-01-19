extends CharacterBody2D

# Defines the lane borders
const FIRST_LANE = 64
const LAST_LANE = 256
# Defines the range the player can jump
const LANE_LENGTH = 64

var gameoverScreen:Control
var overlayScore:Label
var overlayPauseButton:TouchScreenButton
@onready var scoreLable: Label
@onready var highscoreLable : Label

# Called when the node enters the scene tree for the first time.
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
	player_movement()

# Function to handle player movement
func player_movement():
	# Check if the left arrow key is pressed and move the player left if not in the first lane
	if Input.is_action_just_pressed("ui_left") and global_position.x != FIRST_LANE:
		global_position.x -= LANE_LENGTH

	# Check if the right arrow key is pressed and move the player right if not in the last lane
	elif Input.is_action_just_pressed("ui_right") and global_position.x != LAST_LANE:
		global_position.x += LANE_LENGTH

	# Move the player using Godot's built-in move_and_slide function
	move_and_slide()



# Function called when the Player node detects another area entering it
func _on_area_2d_area_entered(area):
	# Set the high score to the current score when the area is entered
	DataScript.setMinigame2_highscore(DataScript.getMinigame2_score())
	highscoreLable.text = "Highscore: " + str(DataScript.getMinigame2_highscore())
	scoreLable.text = "Score: " + str(DataScript.getMinigame2_score())
	get_tree().paused = true
	overlayScore.visible = false
	overlayPauseButton.visible = false
	gameoverScreen.visible = true

	

