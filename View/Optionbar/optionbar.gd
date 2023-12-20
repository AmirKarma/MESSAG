extends Control

@onready var building_rect = $optionbar_rect/buildingRect 
@onready var building_name = $optionbar_rect/building_name
@onready var building_level = $optionbar_rect/building_level
var optionbar_rect_size
var building_image_pos
var optionbar_visibility 
var game_scene
var close_pressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	building_level.text = "Level "
	optionbar_rect_size = self.get_node("optionbar_rect").size
	building_image_pos = building_rect.size/2
	building_rect.get_node("building_image").position = building_image_pos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_building_image(path : String):
	building_rect.get_node("building_image").texture = load(path)
		
func _on_texture_button_pressed():
	optionbar_visibility = false
	close_pressed = true

func _on_close_button_pressed():
	optionbar_visibility = false
	close_pressed = true
	
func hide_optionbar():
	_on_texture_button_pressed()

func is_close_button_pressed():
	return close_pressed == true

func set_optionbar(positon : Vector2, name : String, level : String, image_path : String, game_path : String):
	self.position = positon
	building_name.text = name
	building_level.text += level
	set_building_image(image_path)
	game_scene = game_path



func _on_play_1_button_pressed():
	get_tree().change_scene_to_file(game_scene)


func _on_play_2_button_pressed():
	get_tree().change_scene_to_file("res://Minigame2/minigame2.tscn")
