extends Control

@onready var building_rect = $optionbar_rect/buildingRect 
@onready var building_name = $optionbar_rect/building_name
@onready var building_level = $optionbar_rect/building_level
@onready var play_button:Button = $optionbar_rect/buttons_rect/buttons/play_button
@onready var cancel_button:Button = $optionbar_rect/buttons_rect/CenterContainer/VBoxContainer/HSplitContainer/cancel_button
@onready var confirm_button:Button = $optionbar_rect/buttons_rect/CenterContainer/VBoxContainer/HSplitContainer/confirm_button
@onready var upgrade_button:Button = $optionbar_rect/buttons_rect/buttons/upgrade_button
@onready var costs_lable:Label = $optionbar_rect/buttons_rect/CenterContainer/VBoxContainer/HBoxContainer/costs_lable
@onready var player:CharacterBody2D = get_node("/root/World/Player")
var optionbar_rect_size:Vector2
var building_image_pos:Vector2
var game_scene:String
var building_id:int = 0
var name_index:int = 1
var level_index:int = 2
var upgrade_cost_index:int = 3
var image_index:int = 4
var game_path_index:int = 5
var ressource_amount:int = 6
var max_storage_size:int = 7
# Called when the node enters the scene tree for the first time.
func _ready():
	costs_lable.text = "  " 
	building_level.text = "Level "
	optionbar_rect_size = self.get_node("optionbar_rect").size
	building_image_pos = building_rect.size/2
	building_rect.get_node("building_image").position = building_image_pos

func _on_close_button_pressed():
	hide_optionbar()
	reset_buttons()
	
func hide_optionbar():
	self.visible = false
	player.set_process(true)
	player.set_physics_process(true)
	player.get_node("Camera2D/HUD").visible = true

func set_optionbar(positon : Vector2,id:int):
	self.position = positon
	building_id = id
	building_name.text = DataScript.fieldArray[id][name_index]
	if DataScript.fieldArray[building_id][game_path_index] == "":
		play_button.visible = false
	else:
		play_button.visible = true
		game_scene = DataScript.fieldArray[building_id][game_path_index]
	if id != DataScript.rocket:
		set_building_image()
	else:
		set_rocket_image()
	is_upgradeable()
	set_building_texts()
	set_bars()
	
func set_building_image():
	building_rect.get_node("building_image").play(DataScript.fieldArray[building_id][image_index])
	$optionbar_rect/buildingRect/rocket_image.visible = false
	$optionbar_rect/buildingRect/building_image.visible = true
	
func set_rocket_image():
	building_rect.get_node("rocket_image").texture = load("res://Welt/Rocket/Rakete.png")
	$optionbar_rect/buildingRect/rocket_image.visible = true
	$optionbar_rect/buildingRect/building_image.visible = false

func is_upgradeable():
	if is_max_level():
		upgrade_button.modulate = Color.DIM_GRAY
		upgrade_button.disabled = true

func _on_play_1_button_pressed():
	get_tree().change_scene_to_file(game_scene)

func _on_upgrade_button_pressed():
	upgrade_check()
	$optionbar_rect/buttons_rect/buttons.visible = false
	$optionbar_rect/buttons_rect/CenterContainer.visible = true

func upgrade_check():
	if is_not_enough_mooneten():
		confirm_button.modulate = Color.DIM_GRAY
		confirm_button.disabled = true

func is_not_enough_mooneten():
	return DataScript.getMooneten() < DataScript.fieldArray[building_id][upgrade_cost_index][DataScript.fieldArray[building_id][level_index] - 1]

func is_max_level():
	return DataScript.fieldArray[building_id][level_index] == len(DataScript.fieldArray[building_id][upgrade_cost_index]) + 1

func _on_cancel_button_pressed():
	reset_buttons()

func _on_confirm_button_pressed():
	DataScript.removeMooneten(DataScript.fieldArray[building_id][upgrade_cost_index][DataScript.fieldArray[building_id][level_index] - 1])
	# 3 is the index for the level of the building
	DataScript.edit_building(building_id,level_index, DataScript.fieldArray[building_id][level_index] + 1)
	set_building_texts()
	set_bars()
	is_upgradeable()
	reset_buttons()
	
func set_building_texts():
	if !is_max_level():
		costs_lable.text = "  " + str(DataScript.fieldArray[building_id][upgrade_cost_index][DataScript.fieldArray[building_id][level_index] - 1])
	building_level.text = "Level " + str(DataScript.fieldArray[building_id][level_index])

func set_bars():
	$optionbar_rect/RessorceRect/moonetenbar.visible = true
	$optionbar_rect/RessorceRect/Coin.visible = true
	$optionbar_rect/RessorceRect/energybar.visible = true
	$optionbar_rect/RessorceRect/Moonstone.visible = true
	if DataScript.fieldArray[building_id][0] == 2 || DataScript.fieldArray[building_id][0] == 4:
		$optionbar_rect/RessorceRect/energybar.visible = false
		$optionbar_rect/RessorceRect/Moonstone.visible = false
		$optionbar_rect/RessorceRect/moonetenbar/mooneten_label.text = str(DataScript.fieldArray[building_id][ressource_amount]) + " / " + str(DataScript.fieldArray[building_id][max_storage_size][DataScript.fieldArray[building_id][level_index] - 1])
		$optionbar_rect/RessorceRect/moonetenbar.value = DataScript.fieldArray[building_id][ressource_amount]
		$optionbar_rect/RessorceRect/moonetenbar.max_value = DataScript.fieldArray[building_id][max_storage_size][DataScript.fieldArray[building_id][level_index] - 1]
	if DataScript.fieldArray[building_id][0] == 3 || DataScript.fieldArray[building_id][0] == 5:
		$optionbar_rect/RessorceRect/moonetenbar.visible = false
		$optionbar_rect/RessorceRect/Coin.visible = false
		$optionbar_rect/RessorceRect/energybar/energy_label.text = str(DataScript.fieldArray[building_id][ressource_amount]) + " / " + str(DataScript.fieldArray[building_id][max_storage_size][DataScript.fieldArray[building_id][level_index] - 1])
		$optionbar_rect/RessorceRect/energybar.value = DataScript.fieldArray[building_id][ressource_amount]
		$optionbar_rect/RessorceRect/energybar.max_value = DataScript.fieldArray[building_id][max_storage_size][DataScript.fieldArray[building_id][level_index] - 1]

func reset_buttons():
	$optionbar_rect/buttons_rect/buttons.visible = true
	$optionbar_rect/buttons_rect/CenterContainer.visible = false
	confirm_button.modulate = Color.WHITE
	confirm_button.disabled = false
	upgrade_button.modulate = Color.WHITE
	upgrade_button.disabled = false

