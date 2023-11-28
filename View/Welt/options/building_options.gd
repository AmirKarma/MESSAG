extends Control

@onready var playButton = $Buttons/play
@onready var infoButton = $Buttons/info
@onready var playerScreen = load("res://Player/player.tscn")





# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_miniGame(path: String):
	playButton.set_miniGame(path)


func _on_info_pressed():
	pass # Replace with function body.
