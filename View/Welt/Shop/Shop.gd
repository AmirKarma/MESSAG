extends Node2D

@onready var shop_menu:Control = $shop_menu
@onready var player:CharacterBody2D = get_node("/root/World/Player")
var pressed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	building_distance()

func building_distance():
	if(pressed == true):
		shop_menu.visible = false
		if player.position.distance_to(position) < 50:
			pressed = false
			player.stand_still = true
			player.moving = false
			open_shop()
		else:
			player.moving = true
			player.stand_still = false
			player.nav.target_position = position
			player.animationState.travel("Run")

func open_shop():
	var optionbar_pos = player.get_node("Camera2D").get_screen_center_position() - get_viewport_rect().size / 2
	shop_menu.position = optionbar_pos
	shop_menu.visible = true
	player.stand_still = true
	player.set_process(false)
	player.set_physics_process(false)
	player.get_node("Camera2D/HUD").visible = false

func _on_option_button_pressed():
	pressed = true
	




