extends Button

var miniGame_Path = " "

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _pressed():
	print(miniGame_Path)
	var minigame = load(miniGame_Path).instantiate()
	get_tree().root.add_child(minigame)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = minigame
	pass

func set_miniGame(path: String):
	miniGame_Path = path
	
