extends ParallaxBackground

# Function: _process
# Description: Handles the continuous processing logic over time in the game loop.
# This function updates the scroll base offset based on the given delta time,
# game speed, and a timer value. It also sets the score in a minigame using the
# updated scroll base offset's Y-coordinate.


func _process(delta):
	# Update the scroll base offset using the delta time, game speed, and timer
	scroll_base_offset += delta * DataScript.MINIGAME2_GAMESPEED * DataScript.minigame2_timer

	# Set the score in Minigame 2 using the updated Y-coordinate of the scroll base offset
	DataScript.set_minigame2_score(scroll_base_offset.y)
