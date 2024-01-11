extends Control

# Reference to the points GUI element using the @onready keyword
@onready var points = $Points:
	set(value):
		# Update the text of the points GUI element
		points.text = "Points: " + str(value)

# Reference to the lives GUI element using the @onready keyword
@onready var lives = $Lives:
	set(value):
		# Update the text of the lives GUI element
		lives.text = "Lives: " + str(value)
