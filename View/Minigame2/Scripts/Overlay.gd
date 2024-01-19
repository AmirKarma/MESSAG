extends Control

@onready var score_label: Label = $Score
# Reference to the onready node for the Score label
var score: int = 0:
	# Setter function for the 'score' variable
	set(value):
		# Update the text of the Score label with the new score value
		score_label.text = "Score: " + str(value).pad_decimals(0)
