extends Node2D

@onready var optionButton = $OptionButton
@onready var ShopSprite = $Shop

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
	optionButton.get_popup().position = Vector2(110, 30)

func add_items():
	optionButton.add_item("Kaufen für 10")
	optionButton.add_item("Kaufen für 100")
	optionButton.add_item("Kaufen für 1000")
	optionButton.add_item("Kaufen für 10000")
	optionButton.add_item("Kaufen für 100000")

func _on_option_button_item_selected(index):
	var Mooneten1 = DataScript.getMooneten()
	print(Mooneten1)
	if index == 0:
		if Mooneten1 >= 10:
			print("10 Kaufen")
			# setGebäude1 +1 
			DataScript.setMooneten(Mooneten1 - 10)
		else:
			print("Zu wenig Mooneten")
		pass
	if index == 1:
		if Mooneten1 >= 100:
			print("100 Kaufen")
		else:
			print("Zu wenig Mooneten")
		pass
	if index == 2:
		if Mooneten1 >= 1000:
			print("1000 Kaufen")
		else:
			print("Zu wenig Mooneten")
		pass
	if index == 3:
		if Mooneten1 >= 10000:
			print("10000 Kaufen")
		else:
			print("Zu wenig Mooneten")
		pass
	if index == 4:
		if Mooneten1 >= 100000:
			print("100000 Kaufen")
		else:
			print("Zu wenig Mooneten")
		pass		
		

