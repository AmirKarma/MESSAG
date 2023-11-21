extends Node2D

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
			doSomething()
		elif player.nav.target_position != position - Vector2(20,20):
			pressed = false


func _on_option_button_pressed():
	
	pressed = true
	if player.position.distance_to(position) > 50:
		player.moving = true
		player.nav.target_position = position - Vector2(20,20)
		player.animationState.travel("Run")


func doSomething():
	print("läuft")
