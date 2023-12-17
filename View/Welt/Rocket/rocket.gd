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
	add_items()
		

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
	optionButton.get_popup().hide()
	if player.position.distance_to(position) > 50:
		player.stand_still = false
		player.moving = true
		player.nav.target_position = position - Vector2(20,20)
		player.animationState.travel("Run")


func doSomething():
	optionButton.show_popup()
	optionButton.get_popup().position = Vector2(100, 125)

func add_items():
	optionButton.add_item("Minigame")
	optionButton.add_item("Minigame2")

func _on_option_button_item_selected(index):
	
	if index == 0:
		DataScript.setUnixLastTime(Time.get_unix_time_from_system())
		var minigame = load("res://Minigame1/minigame_1.tscn").instantiate()
		get_tree().root.add_child(minigame)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = minigame
	if index == 1:
		DataScript.setUnixLastTime(Time.get_unix_time_from_system())
		var minigame2 = load("res://Minigame2/minigame2.tscn").instantiate()
		get_tree().root.add_child(minigame2)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = minigame2	
