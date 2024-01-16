extends Node2D

# Nodes for the scene
@onready var player:CharacterBody2D = get_node("/root/World/Player")
@onready var optionbar:Control = get_node("/root/World/Optionbar")

#Variable for the current building index
var building_index:int = 0

var player_is_moving:bool = false

# Function: building_distance
# Description: Checks the distance between the player and a building. If the player is close enough, opens the option bar.
func building_distance(building:Node2D):
	if(building.pressed and !player.player_is_moving):
		optionbar.set_visible(false)
		if player.position.distance_to(building.position) < 50:
			building.pressed = false
			player.stand_still = true
			player.moving = false
			open_optionbar(building.id)
		else:
			player.moving = true
			player.stand_still = false
			player.nav.target_position = building.position
			player.animationState.travel("Run")
	else:
		building.pressed = false

# Function: open_optionbar
# Description: Opens the option bar for a specific building.
func open_optionbar(id:int):
	DataScript.is_in_building_menu = true
	var optionbar_pos = player.get_node("Camera2D").get_screen_center_position() - get_viewport_rect().size / 2
	optionbar.set_optionbar(optionbar_pos,id)
	optionbar.set_visible(true)
	player.stand_still = true
	player.set_process(false)
	player.set_physics_process(false)
	player.get_node("Camera2D/HUD").visible = false

# Function: updateBuildings
# Description: Updates the visibility and animation of building icons based on the data in DataScript.fieldArray.
func updateBuildings(building:Node2D):
	for n in range(1,13):
		if building.id == n:
			if DataScript.fieldArray[n][building_index] == DataScript.moonetenGenerator :
				building.visible = true
				building.icon.play("moonetenGenerator")
				building.mooneten_generator_button.visible = true
			elif DataScript.fieldArray[n][building_index] == DataScript.moonstoneGenerator:
				building.visible = true
				building.icon.play("moonstoneGenerator")
				building.moonstone_generator_button.visible = true
			elif DataScript.fieldArray[n][building_index] == DataScript.moonetenStorage:
				building.visible = true
				building.icon.play("moonetenStorage")
				building.mooneten_storage_button.visible = true
			elif DataScript.fieldArray[n][building_index] == DataScript.moonstoneStorage:
				building.visible = true
				building.icon.play("moonstoneStorage")
				building.moonstone_storage_button.visible = true
			else:
				building.visible = false

