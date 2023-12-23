# Extends the CharacterBody2D class
extends CharacterBody2D

# Maximum speed of the character
var max_speed = 100
# Current speed of the character
var speed = 0
# Acceleration of the character
var acceleration = 400
# Direction in which the character is moving
var move_direction
# Indicates whether the character is moving
var moving = false
# Destination for movement
var destination = Vector2()
# Vector for character movement
var movement = Vector2()
# Indicates whether the free-field key is pressed
var free_field_pressed:bool = false
# Indicates whether the character is standing still
var stand_still:bool = false
# Clicked tile and its center
var clicked_tile
var clicked_tile_center
# Data of the tile and pattern for free fields
var tile_data
var free_field_pattern:Array

var buildingIndex = -1
var fieldIndex = -1

var standart_camerazoom:Vector2 = Vector2(1,1)
var standart_position:Vector2 = Vector2(0,0)

# References to other nodes and resources in the game
@onready var world : Node2D = get_tree().get_root().get_node("World")
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var nav : NavigationAgent2D = $NavigationAgent2D
@onready var map : TileMap = world.get_node('TileMap')
@onready var camera:Camera2D = $Camera2D
@onready var hud:CanvasLayer = get_node("/root/World/Player/Camera2D/HUD")

func _ready():
	$Inventar.connect("_on_buybutton_bought", _on_buybutton_bought)

# Function called when unhandled input occurs
func _unhandled_input(event):
	if camera.zoom == standart_camerazoom:
		if event.is_action_pressed('Click'):
			$Inventar.visible = false
			set_free_field_pressed()
			free_field_distance_check()
			if !stand_still:
				set_pattern()
				moving = true
				nav.target_position = get_global_mouse_position()
				animationState.travel("Run")
	else:
		reset_camera()
		
func reset_camera():
	camera.zoom = standart_camerazoom
	camera.position = standart_position
	hud.visible = true
	modulate = Color.WHITE


# Sets the pattern for free fields if the tile is clickable
func set_pattern():
	if tile_data.get_custom_data('clickable'):
			free_field_pattern = create_pattern()

# Activates the free-field key and sets the click status
func set_free_field_pressed():
	#Tilemapcoords
	clicked_tile = map.local_to_map(get_global_mouse_position())
	#Globalcoords
	clicked_tile_center = map.map_to_local(clicked_tile)
	tile_data = map.get_cell_tile_data(0,clicked_tile)
	if tile_data:
		if tile_data.get_custom_data('clickable'):
			free_field_pressed = true
		else:
			free_field_pressed = false
			stand_still = false

# creates the free field pattern
func create_pattern()-> Array:
	var pattern:Array
	pattern.append(clicked_tile)
	var pattern_index = 0
	while(len(pattern) < 6):
		var surrounding_cells:Array = map.get_surrounding_cells(pattern[pattern_index])
		for i in range(len(surrounding_cells)):
			var tile_data_pattern = map.get_cell_tile_data(0,surrounding_cells[i])
			if tile_data_pattern.get_custom_data('clickable') and !pattern.has(surrounding_cells[i]):
				pattern.append(surrounding_cells[i])
		pattern_index += 1
	return pattern
	
# Called every physics process
func _physics_process(delta):
	MovementLoop(delta)
	free_field_distance_check()
	
# Checks the distance to the free field
func free_field_distance_check():
	if free_field_pressed:
		if (position.distance_to(clicked_tile_center) < 35 or stand_still) and free_field_pattern.has(clicked_tile):
			moving = false
			stand_still = true
			open_menu(clicked_tile_center)
			free_field_pressed = false
		else :
			stand_still = false
			set_pattern()
			
# Opens a menu and returns the index of the field
func open_menu(value):
	fieldIndex = getFieldIndex(value)
	buildingIndex = getBuildingIndex(fieldIndex)
	print(fieldIndex)
	print(buildingIndex)
	if buildingIndex == -1:
		$Inventar.visible = true
	

func _on_buybutton_bought(bIndex):
	$Inventar.visible = false
	print("Ausgewählt: " + str(bIndex))
	if bIndex == 0:
		if DataScript.moneyGeneratorCount > 0:
			DataScript.moneyGeneratorCount = DataScript.moneyGeneratorCount - 1
			setBuilding(fieldIndex, bIndex)
			DataScript.saveFieldData()
	elif bIndex == 1:
		if DataScript.moonstoneGeneratorCount > 0:
			DataScript.moonstoneGeneratorCount = DataScript.moonstoneGeneratorCount - 1
			setBuilding(fieldIndex, bIndex)
			DataScript.saveFieldData()
	elif bIndex == 2:
		if DataScript.moneyStorageCount > 0:
			DataScript.moneyStorageCount = DataScript.moneyStorageCount - 1
			setBuilding(fieldIndex, bIndex)
			DataScript.saveFieldData()
	elif bIndex == 3:
		if DataScript.moonstoneStorageCount > 0:
			DataScript.moonstoneStorageCount = DataScript.moonstoneStorageCount - 1
			setBuilding(fieldIndex, bIndex)
			DataScript.saveFieldData()
	elif bIndex == 4:
		if DataScript.shopCount > 0:
			DataScript.shopCount = DataScript.shopCount - 1
			setBuilding(fieldIndex, bIndex)
			DataScript.saveFieldData()

# Governs character movement
func MovementLoop(delta):
	if !stand_still:
		if moving == false:
			animationState.travel("Idle")
			speed = 0
		else:
			speed += acceleration * delta
			if speed > max_speed:
				speed = max_speed
		movement = position.direction_to(nav.target_position) * speed
		move_direction = nav.get_next_path_position() - global_position
		move_direction = move_direction.normalized()
		if position.distance_to(nav.target_position) > 10:
			animationTree.set("parameters/Idle/blend_position", movement)
			animationTree.set("parameters/Run/blend_position", movement)

			velocity = velocity.lerp(move_direction * speed, speed * delta)
			move_and_slide()
		else:
			moving = false
	else:
		animationState.travel("Idle")
		speed = 0
		
# Returns the index of the field based on the global position
func getFieldIndex(value):
	if(value.x >= 16 && value.x <= 80):
		if(value.y >= 144 && value.y <= 176):
			return 0
	if(value.x >= 144 && value.x <= 208):
		if(value.y >= 48 && value.y <= 80):
			return 1
	if(value.x >= 528 && value.x <= 592):
		if(value.y >= 48 && value.y <= 80):
			return 2
	if(value.x >= 496 && value.x <= 560):
		if(value.y >= -144 && value.y <= -112):
			return 3    
	if(value.x >= 208 && value.x <= 272):
		if(value.y >= -144 && value.y <= -112):
			return 4
	if(value.x >= -144 && value.x <= -80):
		if(value.y >= -144 && value.y <= -112):
			return 5
	if(value.x >= -496 && value.x <= -432):
		if(value.y >= -80 && value.y <= -48):
			return 6
	if(value.x >= -304 && value.x <= -240):
		if(value.y >= 80 && value.y <= 112):
			return 7
	if(value.x >= -176 && value.x <= -112):
		if(value.y >= 240 && value.y <= 272):
			return 8
	if(value.x >= -368 && value.x <= -304):
		if(value.y >= 336 && value.y <= 368):
			return 9
	if(value.x >= 48 && value.x <= 112):
		if(value.y >= 368 && value.y <= 400):
			return 10
	if(value.x >= 336 && value.x <= 400):
		if(value.y >= 432 && value.y <= 464):
			return 11
	if(value.x >= 432 && value.x <= 496):
		if(value.y >= 240 && value.y <= 272):
			return 12
	if(value.x >= 880 && value.x <= 944):
		if(value.y >= 240 && value.y <= 272):
			return 13
	return -1
	
func getBuildingIndex(value):
	if(value == 0):
		return DataScript.fieldZero
	if(value == 1):
		return DataScript.fieldOne
	if(value == 2):
		return DataScript.fieldTwo
	if(value == 3):
		return DataScript.fieldThree
	if(value == 4):
		return DataScript.fieldFour
	if(value == 5):
		return DataScript.fieldFive
	if(value == 6):
		return DataScript.fieldSix
	if(value == 7):
		return DataScript.fieldSeven
	if(value == 8):
		return DataScript.fieldEight
	if(value == 9):
		return DataScript.fieldNine
	if(value == 10):
		return DataScript.fieldTen
	if(value == 11):
		return DataScript.fieldEleven
	if(value == 12):
		return DataScript.fieldTwelve
	if(value == 13):
		return DataScript.fieldThirteen
		
func player_shop_method():
	pass
	
func setBuilding(value, bIndex):
	if(value == 0):
		DataScript.fieldZero = bIndex
	if(value == 1):
		DataScript.fieldOne = bIndex
	if(value == 2):
		DataScript.fieldTwo = bIndex
	if(value == 3):
		DataScript.fieldThree = bIndex
	if(value == 4):
		DataScript.fieldFour = bIndex
	if(value == 5):
		DataScript.fieldFive = bIndex
	if(value == 6):
		DataScript.fieldSix = bIndex
	if(value == 7):
		DataScript.fieldSeven = bIndex
	if(value == 8):
		DataScript.fieldEight = bIndex
	if(value == 9):
		DataScript.fieldNine = bIndex
	if(value == 10):
		DataScript.fieldTen = bIndex
	if(value == 11):
		DataScript.fieldEleven = bIndex
	if(value == 12):
		DataScript.fieldTwelve = bIndex
	if(value == 13):
		DataScript.fieldThirteen = bIndex
