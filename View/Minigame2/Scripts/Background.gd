## This script extends the ParallaxBackground class and handles continuous processing logic
## in the game loop. It updates the scroll base offset based on the given delta time, game speed,
## and timer value. Additionally, it sets the score in a minigame using the updated scroll base
## offset's Y-coordinate.

extends ParallaxBackground

# Function: _process
## Handles the continuous processing logic over time in the game loop. Updates the scroll base offset
## based on the given delta time, game speed, and timer value. Additionally, sets the score in a minigame
## using the updated scroll base offset's Y-coordinate.
func _process(delta):
	# Update the scroll base offset using the delta time, game speed, and timer
	scroll_base_offset += delta * DataScript.MINIGAME2_GAMESPEED * DataScript.minigame2_timer

	# Set the score in Minigame 2 using the updated Y-coordinate of the scroll base offset
	DataScript.set_minigame2_score(scroll_base_offset.y)
