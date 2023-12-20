# This script extends the Node2D class
# This script handles behavior and interactions for a 2D node in the game.

extends Node2D

@onready var optionbar = $optionbar
@onready var player = $Player
var optionbar_pos

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
	elif optionbar.is_close_button_pressed():
		hide_optionbar()
		
		
			
func open_optionbar(building : Node):
	if building.pressed:
		if player.position.distance_to(building.position) < 50:
			building.pressed = false
			optionbar_pos = player.get_node("Camera2D").get_screen_center_position() - get_viewport_rect().size / 2
			optionbar.set_optionbar(optionbar_pos,"Rocket","1",building.get_node("rocketSprite").texture.resource_path , "res://Minigame1/minigame_1.tscn")
			optionbar.set_visible(true)
			optionbar.close_pressed = false
			player.set_process(false)
			player.set_physics_process(false)
			player.get_node("Camera2D/HUD").visible = false
		elif player.nav.target_position != building.position - Vector2(20,20):			
			building.pressed = false

func hide_optionbar():
	optionbar.set_visible(false)
	player.set_process(true)
	player.set_physics_process(true)
	player.get_node("Camera2D/HUD").visible = true

		
