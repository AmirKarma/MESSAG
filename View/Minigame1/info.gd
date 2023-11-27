extends Control

@onready var punkte = $Punkte:
	set(value):
		punkte.text = "Punkte: "+ str(value)
