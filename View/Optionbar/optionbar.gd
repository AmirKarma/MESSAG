extends Control

@onready var building_rect = $optionbar_rect/buildingRect 
@onready var building_name = $optionbar_rect/building_name
@onready var building_level = $optionbar_rect/building_level
@onready var cancel_button:Button = $optionbar_rect/buttons_rect/CenterContainer/VBoxContainer/HSplitContainer/cancel_button
@onready var confirm_button:Button = $optionbar_rect/buttons_rect/CenterContainer/VBoxContainer/HSplitContainer/confirm_button
@onready var costs_lable:Label = $optionbar_rect/buttons_rect/CenterContainer/VBoxContainer/HBoxContainer/costs_lable
var optionbar_rect_size
var building_image_pos
var optionbar_visibility 
var game_scene
var close_pressed = false
var upgrade_costs:Array = [100,1000,2000,10000] #TODO in datascript und andere Werte die sinn machen
# Called when the node enters the scene tree for the first time.
func _ready():
	costs_lable.text = "  " + str(upgrade_costs[DataScript.get_rocket_level() - 1])
	building_level.text = "Level "
	optionbar_rect_size = self.get_node("optionbar_rect").size
	building_image_pos = building_rect.size/2
	building_rect.get_node("building_image").position = building_image_pos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	building_level.text = "Level " + str(DataScript.get_rocket_level())
	
func set_building_image(path : String):
	building_rect.get_node("building_image").texture = load(path)
		
func _on_texture_button_pressed():
	optionbar_visibility = false
	close_pressed = true

func _on_close_button_pressed():
	optionbar_visibility = false
	close_pressed = true
	reset_buttons()
	
func hide_optionbar():
	_on_texture_button_pressed()

func is_close_button_pressed():
	return close_pressed == true

func set_optionbar(positon : Vector2, name : String, image_path : String, game_path : String):
	self.position = positon
	building_name.text = name
	set_building_image(image_path)
	game_scene = game_path

func _on_play_1_button_pressed():
	get_tree().change_scene_to_file(game_scene)


func _on_play_2_button_pressed():
	get_tree().change_scene_to_file("res://Minigame2/minigame2.tscn")

func _on_upgrade_button_pressed():
	upgrade_check()
	$optionbar_rect/buttons_rect/buttons.visible = false
	$optionbar_rect/buttons_rect/CenterContainer.visible = true


func upgrade_check():
	if DataScript.getMooneten() < upgrade_costs[DataScript.get_rocket_level() - 1]:
		confirm_button.modulate = Color.DIM_GRAY
		confirm_button.disabled = true

func _on_cancel_button_pressed():
	reset_buttons()

func _on_confirm_button_pressed():
	DataScript.removeMooneten(upgrade_costs[DataScript.get_rocket_level() - 1])
	DataScript.set_rocket_level(1) 
	reset_buttons()

func reset_buttons():
	$optionbar_rect/buttons_rect/buttons.visible = true
	$optionbar_rect/buttons_rect/CenterContainer.visible = false
	confirm_button.modulate = Color.WHITE
	confirm_button.disabled = false
