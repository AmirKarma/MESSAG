extends Node2D
var id:int = 0
@onready var buildings:Node2D = get_node("/root/World/buildings")
var pressed: bool = false

func _process(delta):
	buildings.building_distance(self)

func _on_option_button_pressed():
	pressed = true

