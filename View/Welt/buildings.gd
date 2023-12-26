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


func hide_optionbar(optionbar:Control):
	optionbar.set_visible(false)
	player.set_process(true)
	player.set_physics_process(true)
	player.get_node("Camera2D/HUD").visible = true

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

func getFieldIndex(value):
	if(value.x >= 16 && value.x <= 80):
		if(value.y >= 144 && value.y <= 176):
			return 0
	if(value.x >= 144 && value.x <= 208):
		if(value.y >= 48 && value.y <= 80):
			return 1
	if(value.x >= 528 && value.x <= 592):
		if(value.y >= 48 && value.y <= 80):
			return 2
	if(value.x >= 496 && value.x <= 560):
		if(value.y >= -144 && value.y <= -112):
			return 3    
	if(value.x >= 208 && value.x <= 272):
		if(value.y >= -144 && value.y <= -112):
			return 4
	if(value.x >= -144 && value.x <= -80):
		if(value.y >= -144 && value.y <= -112):
			return 5
	if(value.x >= -496 && value.x <= -432):
		if(value.y >= -80 && value.y <= -48):
			return 6
	if(value.x >= -304 && value.x <= -240):
		if(value.y >= 80 && value.y <= 112):
			return 7
	if(value.x >= -176 && value.x <= -112):
		if(value.y >= 240 && value.y <= 272):
			return 8
	if(value.x >= -368 && value.x <= -304):
		if(value.y >= 336 && value.y <= 368):
			return 9
	if(value.x >= 48 && value.x <= 112):
		if(value.y >= 368 && value.y <= 400):
			return 10
	if(value.x >= 336 && value.x <= 400):
		if(value.y >= 432 && value.y <= 464):
			return 11
	if(value.x >= 432 && value.x <= 496):
		if(value.y >= 240 && value.y <= 272):
			return 12
	if(value.x >= 880 && value.x <= 944):
		if(value.y >= 240 && value.y <= 272):
			return 13
	return -1
