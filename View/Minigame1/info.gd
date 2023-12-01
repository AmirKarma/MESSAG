extends Control

@onready var punkte = $Punkte:
	set(value):
		punkte.text = "Punkte: "+ str(value)
		
@onready var leben = $Leben:
	set(value):
		leben.text = "Leben: "+ str(value)		
