extends ParallaxBackground


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#defines the speed of the background, with the timer and delta its getting faster by time
	scroll_base_offset += delta *DataScript.minigame2_gameSpeed * DataScript.minigame2_timer
	DataScript.setMinigame2_score(scroll_base_offset.y)
