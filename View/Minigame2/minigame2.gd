extends Node2D

var xValues = [64,128,192,256]



# Called when the node enters the scene tree for the first time.
func _ready():
	DataScript.minigame2_timer = 1

func _on_timer_timeout():
	print('timeout')
	match str(DataScript.minigame2_timer).pad_decimals(0):
		'2':
			DataScript.minigame2_timerSpeed = 0.005 
			#cometSpeedValues[0] = Vector2(0,60)
		'3': 
			DataScript.minigame2_timerSpeed  = 0.0025 
			#cometSpeedValues[1] = Vector2(0,70)
			#commetSpawnCount = 2
		'4': 
			DataScript.minigame2_timerSpeed  = 0.00125 
			#cometSpeedValues[2] = Vector2(0,80)
		#'5':
			#cometSpeedValues[3] = Vector2(0,90)
			#commetSpawnCount = 3
		
	DataScript.minigame2_timer += DataScript.minigame2_timerSpeed


func _on_touch_screen_button_pressed():
	var world = load("res://Welt/world.tscn").instantiate()
	get_tree().root.add_child(world)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = world
