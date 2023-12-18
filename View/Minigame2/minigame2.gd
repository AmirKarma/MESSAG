extends Node2D

var xValues = [64,128,192,256]



# Called when the node enters the scene tree for the first time.
func _ready():
	DataScript.minigame2_timer = 3


func _on_timer_timeout():
	match str(DataScript.minigame2_timer).pad_decimals(0):
		'4':
			DataScript.minigame2_timerSpeed = 0.005 
			#cometSpeedValues[0] = Vector2(0,60)
		'5': 
			DataScript.minigame2_timerSpeed  = 0.0025 
			#cometSpeedValues[1] = Vector2(0,70)
			#commetSpawnCount = 2
		'6': 
			DataScript.minigame2_timerSpeed  = 0.00125 
			#cometSpeedValues[2] = Vector2(0,80)
		#'7':
			#cometSpeedValues[3] = Vector2(0,90)
			#commetSpawnCount = 3
		
	DataScript.minigame2_timer += DataScript.minigame2_timerSpeed
