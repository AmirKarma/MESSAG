extends Node2D

# Nodes for the scene
@onready var shop_menu:Control = $shop_menu
@onready var player:CharacterBody2D = get_node("/root/World/Player")

# Variable holdes the value of pressed
var pressed: bool = false

# Function: _process
# Description: Called every frame. Executes the 'building_distance' function.
func _process(_delta):
	building_distance()

# Function: building_distance
# Description: Checks the distance between the player and the building. If the 'pressed' variable is true and the player is close enough to the building,
#              it opens the shop menu, sets the player's state, and triggers the 'open_shop' function.
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

# Function: open_shop
# Description: Opens the shop menu. Calculates the position of the shop menu relative to the player's camera.
func open_shop():
	var optionbar_pos = player.get_node("Camera2D").get_screen_center_position() - get_viewport_rect().size / 2
	shop_menu.set_shop()
	shop_menu.position = optionbar_pos
	shop_menu.visible = true
	player.stand_still = true
	player.set_process(false)
	player.set_physics_process(false)
	player.get_node("Camera2D/HUD").visible = false

# Function: _on_option_button_pressed
# Description: Called when the option button is pressed. Sets the 'pressed' variable to true.
func _on_option_button_pressed():
	pressed = true
	




