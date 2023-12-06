extends Control

@onready var scoreLable = $ScoreLable:
	set(value):
		scoreLable.text = "Your Score: " + str(value).pad_decimals(0)
		
func _ready():
	scoreLable = 1 #hier muss der Score eingetragen werden, anstatt der 1
