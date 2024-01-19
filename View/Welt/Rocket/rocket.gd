extends Node2D

@onready var optionButton = $OptionButton
@onready var rocketSprite = $rocketSprite

var pressed: bool = false
var world
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	world = get_tree().get_root().get_node("World")
	player = world.get_node("Player")
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pressed:
		if player.position.distance_to(position) < 50:
			pressed = false
		elif player.nav.target_position != position - Vector2(20,20):
			pressed = false


func _on_option_button_pressed():
	pressed = true
	optionButton.get_popup().hide()
	if player.position.distance_to(position) > 50:
		player.stand_still = false
		player.moving = true
		player.nav.target_position = position - Vector2(20,20)
		player.animationState.travel("Run")

