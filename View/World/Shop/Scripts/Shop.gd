## This script manages interactions with the Shop in the game world, such as opening the shop menu when the player interacts with it.

extends Node2D

## Variable holdes the value of pressed
var pressed: bool = false

## Reference to the shop menu node in the scene
@onready var shop_menu: Control = $shop_menu

## Reference to the player character node using the CharacterBody2D class
@onready var player: CharacterBody2D = get_node("/root/World/Player")


# Function: _process
## Called every frame. Executes the 'building_distance' function.
func _process(_delta):
	building_distance()

# Function: _on_option_button_pressed
## Called when the option button is pressed. Sets the 'pressed' variable to true.
func _on_option_button_pressed():
	pressed = true
		

# Function: building_distance
## Checks the distance between the player and the building. If the 'pressed' variable is true and the player is close enough to the building,
## it opens the shop menu, sets the player's state, and triggers the 'open_shop' function.
func building_distance():
	if player.camera.zoom == player.standart_camerazoom:
		if pressed and !player.player_is_moving :
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
		else:
			pressed = false
	else:
		pressed = false



# Function: open_shop
## Opens the shop menu. Calculates the position of the shop menu relative to the player's camera.
func open_shop():
	DataScript.is_in_building_menu = true
	var optionbar_pos: Vector2 = (
		player.get_node("Camera2D").get_screen_center_position() - get_viewport_rect().size / 2
	)
	shop_menu.set_shop()
	shop_menu.position = optionbar_pos
	shop_menu.visible = true
	player.stand_still = true
	player.get_node("Camera2D/HUD").visible = false

