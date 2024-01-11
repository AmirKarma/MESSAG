extends Control

# Holds the current value for a timer in seconds.
var timer_seconds

# Reference to the node managing a countdown in the game.
var countdown 

# Reference to the label node displaying countdown information.
var countdownLable

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
	countdownLable = get_parent().get_node("Countdown/CountdownLable")
	is_paused = false
	timer_seconds = 2

# Function: _unhandled_input
# Description: Handles unhandled input events.
# Toggles the pause state and updates the game's paused status when the "pause" action is pressed.
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused
		get_tree().paused = is_paused


# Function: _on_resume_pressed
# Description: Handles the event when the resume button is pressed.
# Resumes the game, makes the countdown visible, and starts the pause timer.
func _on_resume_pressed():
	self.is_paused = false
	countdown.visible = true
	$PauseTimer.start()


# Function: _on_exit_pressed
# Description: Handles the event when the exit button is pressed.
# Resumes the game, loads the "world.tscn" scene, replaces the current scene with the new world scene.
func _on_exit_pressed():
	self.is_paused = false
	get_tree().paused = is_paused
	var world = load("res://Welt/world.tscn").instance()
	get_tree().root.add_child(world)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = world


# Function: _on_pause_timer_timeout
# Description: Handles the timeout event of the pause timer.
# Updates the countdown label, resets the timer, hides the countdown, stops the timer, and manages the game's paused state.
func _on_pause_timer_timeout():
	if timer_seconds > 0:
		countdownLable.text = str(timer_seconds)
		timer_seconds -= 1
	else:
		timer_seconds = 2
		countdownLable.text = str(3)
		countdown.visible = false
		$PauseTimer.stop()
		get_tree().paused = is_paused

