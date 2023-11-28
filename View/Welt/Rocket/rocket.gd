extends Node2D

@onready var rocketSprite = $rocketSprite

var pressed: bool = false
var world
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass			

func _on_option_button_item_selected(index):
	
	if index == 0:
		DataScript.setUnixLastTime(Time.get_unix_time_from_system())
		var minigame = load("res://Minigame1/minigame_1.tscn").instantiate()
		get_tree().root.add_child(minigame)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = minigame
