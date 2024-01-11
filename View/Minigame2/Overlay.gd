extends Control

# Reference to the onready node for the Score label
@onready var score = $Score:

	# Setter function for the 'score' variable
	set(value):
		# Update the text of the Score label with the new score value
		score.text = "Score: " + str(value).pad_decimals(0)

