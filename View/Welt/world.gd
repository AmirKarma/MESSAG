extends Node2D

# Called when the node enters the scene tree for the first time.
@onready var player = $Player
@onready var rocket = $Rocket
func _ready():
	show_option()
	y_sort_enabled = true

	
func _process(_delta):

	show_option()
	if Input.is_action_just_pressed("debug"):
		var minigame = load("res://Minigame1/minigame_1.tscn").instantiate()
		get_tree().root.add_child(minigame)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = minigame

func show_option():
	if player.position.distance_to(rocket.position) < 50:
		print(player.position)
		print(rocket.position)
		player.show_options("res://Minigame1/minigame_1.tscn")
	else:
		player.hide_options()
	get_tree().set_auto_accept_quit(false)
	
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		DataScript.setUnixLastTime(Time.get_unix_time_from_system())
		get_tree().quit()
	elif what == NOTIFICATION_WM_GO_BACK_REQUEST:
		DataScript.setUnixLastTime(Time.get_unix_time_from_system())
		get_tree().quit()
