extends Control


@onready var scoreLable = $scoreLableMain
@onready var highscoreLable = $highscoreLableMain


		
		
func _ready():
	highscoreLable.text = "Highscore: " + str(DataScript.getM1HighScore())
	scoreLable.text = "Your Score: " + str(DataScript.getM1Score())
	
