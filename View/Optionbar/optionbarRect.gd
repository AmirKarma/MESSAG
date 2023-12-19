extends NinePatchRect

@onready var buildingRect = $buildingRect 
var optionbarRectSize = self.size
var buildingImagePos

# Called when the node enters the scene tree for the first time.
func _ready():
	buildingImagePos = buildingRect.size/2
	buildingRect.get_child(0).position = buildingImagePos
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_building_image(path : String):
	buildingRect.get_child(0).texture = load(path)
	
func _on_texture_button_pressed():
	self.hide()	
