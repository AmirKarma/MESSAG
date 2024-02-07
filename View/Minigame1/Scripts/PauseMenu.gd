## This script controls the pause behavior in the game, including displaying a countdown
## and the ability to pause and resume the game. It includes functions for managing
## the pause state, updating the countdown timer, and switching game scenes.

extends Control

## Holds the current value for a timer in seconds.
var timer_seconds: int

## Reference to the node managing a countdown in the game.
var countdown: Control

## Reference to the label node displaying countdown information.
var countdown_label: Label

## Reference to the label node displaying the Gameover Screen information.
var game_over_screen: Control

## Controls the pause state in the game.
var is_paused:
	set(value):
		is_paused = value
		visible = is_paused


# Function: _ready
## Called when the node enters the scene tree for the first time.
## Initializes references to the countdown nodes, sets initial variables for pause state and timer.
func _ready():
	game_over_screen = get_node("/root/minigame1/Points/GameOverScreen")
	countdown = get_parent().get_node("Countdown")
	countdown_label = countdown.get_node("CountdownLabel")
	is_paused = false
	timer_seconds = 2


# Function: _unhandled_input
## Handles unhandled input events.
## Toggles the pause state and updates the game's paused status when the "pause" action is pressed.
func _unhandled_input(event):
	if event.is_action_pressed("pause") and !game_over_screen.visible:
		is_paused = true
		set_game_state()


# Function: _on_resume_pressed
## Handles the event when the resume button is pressed.
## Resumes the game, makes the countdown visible, and starts the pause timer.
func _on_resume_pressed():
	is_paused = false
	countdown.visible = true
	$PauseTimer.start()


# Function: _on_exit_pressed
## Handles the event when the exit button is pressed.
## Resumes the game, loads the "world.tscn" scene, replaces the current scene with the new world scene.
func _on_exit_pressed():
	is_paused = false
	load_world_scene()
	
# Function: _on_pause_timer_timeout
## Handles the timeout event of the pause timer.
## Updates the countdown label, resets the timer, hides the countdown, stops the timer, and manages the game's paused state.
func _on_pause_timer_timeout():
	if timer_seconds > 0:
		update_countdown_label()
	else:
		reset_countdown()


# Function: set_game_state
## Sets the game state to either paused or unpaused based on the value of 'is_paused'.
## If 'is_paused' is true, the game is paused; otherwise, it is unpaused.
func set_game_state():
	get_tree().paused = is_paused


## Loads and switches to the "world.tscn" scene.
func load_world_scene():
	get_tree().change_scene_to_file("res://World/Scene/world.tscn")
	get_tree().paused = false



#	Function: update_countdown_label
##	Updates the countdown label with the current timer value.
func update_countdown_label():
	countdown_label.text = str(timer_seconds)
	timer_seconds -= 1


#	Function: reset_countdown
##	Resets the countdown values and manages related actions.
func reset_countdown():
	timer_seconds = 2
	countdown_label.text = str(3)
	countdown.visible = false
	$PauseTimer.stop()
	set_game_state()
