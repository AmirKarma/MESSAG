extends Control

# Holds the current value for a timer in seconds.
var timer_seconds: int

# Reference to the node managing a countdown in the game.
var countdown: Control

# Reference to the label node displaying countdown information.
var countdown_label: Label

# Controls the pause state in the game.
var is_paused:
	set(value):
		is_paused = value
		visible = is_paused


# Function: _ready
# Description: Called when the node enters the scene tree for the first time.
# Initializes references to the countdown nodes, sets initial variables for pause state and timer.
func _ready():
	countdown = get_parent().get_node("Countdown")
	countdown_label = countdown.get_node("CountdownLabel")
	is_paused = false
	timer_seconds = 2


# Function: _unhandled_input
# Description: Handles unhandled input events.
# Toggles the pause state and updates the game's paused status when the "pause" action is pressed.
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		toggle_pause_state()
		set_game_state()


# Function: toggle_pause_state
# Description: Toggles the game's pause state and handles related actions.
func toggle_pause_state():
	is_paused = !is_paused


# Function: set_game_state
# Description: Sets the game state to either paused or unpaused based on the value of 'is_paused'.
#              If 'is_paused' is true, the game is paused; otherwise, it is unpaused.
func set_game_state():
	get_tree().paused = is_paused


# Function: _on_resume_pressed
# Description: Handles the event when the resume button is pressed.
# Resumes the game, makes the countdown visible, and starts the pause timer.
func _on_resume_pressed():
	toggle_pause_state()
	countdown.visible = true
	$PauseTimer.start()


# Function: _on_exit_pressed
# Description: Handles the event when the exit button is pressed.
# Resumes the game, loads the "world.tscn" scene, replaces the current scene with the new world scene.
func _on_exit_pressed():
	toggle_pause_state()
	load_world_scene()


# Description: Loads and switches to the "world.tscn" scene.
func load_world_scene():
	get_tree().change_scene_to_file("res://Welt/world.tscn")
	get_tree().paused = false


# Function: _on_pause_timer_timeout
# Description: Handles the timeout event of the pause timer.
# Updates the countdown label, resets the timer, hides the countdown, stops the timer, and manages the game's paused state.
func _on_pause_timer_timeout():
	if timer_seconds > 0:
		update_countdown_label()
	else:
		reset_countdown()


# Function: update_countdown_label
# Description: Updates the countdown label with the current timer value.
func update_countdown_label():
	countdown_label.text = str(timer_seconds)
	timer_seconds -= 1


# Function: reset_countdown
# Description: Resets the countdown values and manages related actions.
func reset_countdown():
	timer_seconds = 2
	countdown_label.text = str(3)
	countdown.visible = false
	$PauseTimer.stop()
	set_game_state()
