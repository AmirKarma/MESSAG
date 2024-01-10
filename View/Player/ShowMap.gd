extends Button

# Variables for the nodes of the scene
@onready var camera:Camera2D = get_node("/root/World/Player/Camera2D")
@onready var hud:CanvasLayer = get_node("/root/World/Player/Camera2D/HUD")
@onready var player:CharacterBody2D = get_node("/root/World/Player")

# Function: _pressed
# Description: Handles the button press event. Sets HUD visibility to false,
# changes player modulation to red, and adjusts camera zoom and position.
func _pressed():
	hud.visible = false
	player.modulate = Color.RED
	camera.zoom = Vector2(0.18,0.2)
	camera.position = Vector2(248,160) - player.position
	
	

