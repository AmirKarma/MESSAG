## This script handles the GUI elements for displaying the player's points and remaining lives.

extends Control

## Reference to the points GUI element using the @onready keyword
@onready var points_label: Label = $Points


## Reference to the lives GUI element using the @onready keyword
@onready var lives_label: Label = $Lives

## Variable to store the player's points.
var points: int = 0:
	set(value):
		# Update the text of the points GUI element
		points_label.text = "Points: " + str(value)

## Variable to store the player's remaining lives.
var lives: int = 0:
	set(value):
		# Update the text of the lives GUI element
		lives_label.text = "Lives: " + str(value)

