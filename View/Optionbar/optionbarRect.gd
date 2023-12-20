extends NinePatchRect

@onready var building_rect = $buildingRect 
var optionbar_rect_size = self.size
var building_image_pos
var optionbar_visibility 
var close_pressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	building_image_pos = building_rect.size/2
	building_rect.get_child(0).position = building_image_pos
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_building_image(path : String):
	building_rect.get_child(0).texture = load(path)
		


func hide_optionbar():
	_on_texture_button_pressed()
