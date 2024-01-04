extends Node2D


@onready var player:CharacterBody2D = get_node("/root/World/Player")
@onready var optionbar:Control = get_node("/root/World/Optionbar")
var building_index:int = 0


func building_distance(building:Node2D):
	if(building.pressed == true):
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
		
func open_optionbar(id:int):
	var optionbar_pos = player.get_node("Camera2D").get_screen_center_position() - get_viewport_rect().size / 2
	optionbar.set_optionbar(optionbar_pos,id)
	optionbar.set_visible(true)
	player.stand_still = true
	player.set_process(false)
	player.set_physics_process(false)
	player.get_node("Camera2D/HUD").visible = false

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

