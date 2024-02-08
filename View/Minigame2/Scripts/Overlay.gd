## This script manages the score display of Minigame 2.

extends Control

## Reference to the onready node for the Score label
@onready var score_label: Label = $Score

## Setter function for the 'score' variable
var score: int = 0:
	set(value):
		# Update the text of the Score label with the new score value
		score_label.text = "Score: " + str(value).pad_decimals(0)
