extends Node2D

var id := 4
@onready var buildings:Node2D = get_node("/root/World/buildings")
@onready var icon:AnimatedSprite2D = $icon
@onready var mooneten_generator_button:Button = $MoonetenGeneratorButton
@onready var moonstone_generator_button:Button = $MoonstoneGeneratorButton
@onready var mooneten_storage_button:Button = $MoonetenStorageButton
@onready var moonstone_storage_button:Button = $MoonstoneStorageButton
var pressed:bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	buildings.updateBuildings(self)
	buildings.building_distance(self)
	
func _on_mooneten_generator_button_pressed():
	pressed = true

func _on_mooneten_storage_button_pressed():
	pressed = true

func _on_moonstone_generator_button_pressed():
	pressed = true

func _on_moonstone_storage_button_pressed():
	pressed = true
