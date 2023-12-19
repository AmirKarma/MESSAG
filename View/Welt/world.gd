# This script extends the Node2D class
# This script handles behavior and interactions for a 2D node in the game.

extends Node2D

@onready var optionbar = $optionbar
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	y_sort_enabled = true
	get_tree().set_auto_accept_quit(false)
	print()
	
# Process function called every frame
func _process(_delta):
		if Input.is_action_just_pressed("debug"):
			var minigame = load("res://Minigame1/minigame_1.tscn").instantiate()
			get_tree().root.add_child(minigame)
			get_tree().current_scene.queue_free()
			get_tree().current_scene = minigame
		building_distance(self.get_child(2)) 

# Notification function called for window management events
func _notification(what):
	# Handle a close request from the window manager
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		DataScript.setUnixLastTime(Time.get_unix_time_from_system())
		get_tree().quit()
	# Handle a go back request from the window manager
	elif what == NOTIFICATION_WM_GO_BACK_REQUEST:
		DataScript.setUnixLastTime(Time.get_unix_time_from_system())
		get_tree().quit()

func building_distance(building : Node):
	if(building.pressed == true):
		optionbar.set_visible(false)
		if player.position.distance_to(building.position) > 50:
			player.stand_still = false
			player.moving = true
			player.nav.target_position = building.position - Vector2(20,20)
			player.animationState.travel("Run")
		open_optionbar(building)
		
			
func open_optionbar(building : Node):
	if building.pressed:
		if player.position.distance_to(building.position) < 50:
			building.pressed = false
			optionbar.get_node("optionbarRect").set_building_image(building.get_node("rocketSprite").texture.resource_path)
			optionbar.position = player.get_node("Camera2D").get_screen_center_position() - get_viewport_rect().size / 2 
			optionbar.show()
		elif player.nav.target_position != building.position - Vector2(20,20):
			optionbar.set_visible(false)
			building.pressed = false
