extends ParallaxBackground


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scroll_base_offset += delta *DataScript.minigame2_gameSpeed * DataScript.minigame2_timer
	#Global.score = scroll_base_offset.y
