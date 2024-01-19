# Extends the CharacterBody2D class
extends CharacterBody2D

# Maximum speed of the character
var max_speed: int = 100

# Current speed of the character
var speed: int = 0

# Acceleration of the character
var acceleration: int = 400

# Direction in which the character is moving
var move_direction: Vector2

# Indicates whether the character is moving
var moving: bool = false

# Destination for movement
var destination: Vector2 = Vector2()

# Vector for character movement
var movement: Vector2 = Vector2()

# Indicates whether the free-field key is pressed
var free_field_pressed: bool = false

# Indicates whether the character is standing still
var stand_still: bool = false

# Clicked tile and its center
var clicked_tile: Vector2i
var clicked_tile_center: Vector2i

# Data of the tile and pattern for free fields
var tile_data
var free_field_pattern: Array

# Holds the index of the current building and the current field.
var buildingIndex: int = -1
var fieldIndex: int = -1

# Represents the index for the building type in data structures.
const building_type: int = 0

# Represents the index for the building level in data structures.
const building_level: int = 2

# Represents the standard camera zoom.
var standart_camerazoom: Vector2 = Vector2(1, 1)

# Represents the standard camera position.
var standart_position: Vector2 = Vector2(0, 0)

# References to other nodes and resources in the game
@onready var world: Node2D = get_tree().get_root().get_node("World")
@onready var buildings: Node2D = world.get_node("buildings")
@onready var animationPlayer: Node = $AnimationPlayer
@onready var animationTree: Node = $AnimationTree
@onready
var animationState: AnimationNodeStateMachinePlayback = animationTree.get("parameters/playback")
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var map: TileMap = world.get_node("TileMap")
@onready var camera: Camera2D = $Camera2D
@onready var hud: CanvasLayer = get_node("/root/World/Player/Camera2D/HUD")
@onready var resourceBar: Control = get_node("/root/World/Player/Camera2D/HUD/RessourceBar")
@onready var mapButton: TextureButton = get_node("/root/World/Player/Camera2D/HUD/showMap")

var mapShowPressed: bool = false
var showMapTexture: Resource = load("res://Player/mapShow.png")
var exitMapTexture: Resource = load("res://Player/mapExit.png")

var screen_is_pressed: bool = false
var player_is_moving: bool = false


# Function: _unhandled_input
# Description: Handles unhandled input events, specifically for mouse clicks.
# If not in the building menu, the camera zoom is at the standard value,
# and the 'Click' action is pressed, sets the screen_is_pressed flag to true,
# and calls the set_free_field_pressed function.
# If the 'Click' action is released, sets the screen_is_pressed flag to false.
# If the camera zoom is not at the standard value, calls the reset_camera function.
func _unhandled_input(event):
	if !DataScript.is_in_building_menu:
		if camera.zoom == standart_camerazoom:
			if event.is_action_pressed("Click"):
				player_is_moving = true
				screen_is_pressed = true
				set_free_field_pressed()
			if event.is_action_released("Click"):
				player_is_moving = false
				screen_is_pressed = false
		else:
			reset_camera()


# Function: player_movement
# Description: Manages player movement based on screen touch input.
# If the screen is pressed and the player is not instructed to stand still,
# sets the movement pattern, enables movement, sets the target position to the global mouse position,
# and triggers the "Run" animation state.
func player_movement():
	if screen_is_pressed:
		if !stand_still:
			set_pattern()
			moving = true
			nav.target_position = get_global_mouse_position()
			animationState.travel("Run")


# Function: reset_camera
# Description: Resets the camera properties to default values, makes the resource bar visible,
# and sets the modulate color to white.
func reset_camera():
	camera.zoom = standart_camerazoom
	camera.position = standart_position
	resourceBar.visible = true
	modulate = Color.WHITE
	mapButton.texture_normal = showMapTexture


# Function: set_pattern
# Description: Sets the free field pattern if the tile data is clickable.
func set_pattern():
	if tile_data.get_custom_data("clickable"):
		free_field_pattern = create_pattern()


# Function: set_free_field_pressed
# Description: Sets the free field pressed state based on the clicked tile's data.
# If the tile is clickable, the state is set to true; otherwise, it's set to false.
func set_free_field_pressed():
	#Tilemapcoords
	clicked_tile = map.local_to_map(get_global_mouse_position())
	#Globalcoords
	clicked_tile_center = map.map_to_local(clicked_tile)
	tile_data = map.get_cell_tile_data(0, clicked_tile)
	if tile_data:
		if tile_data.get_custom_data("clickable"):
			free_field_pressed = true
		else:
			free_field_pressed = false
			stand_still = false


# Function: create_pattern
# Description: Creates a pattern of clickable tiles around the clicked tile, up to a limit of 6.
# Returns the pattern as an Array.
func create_pattern() -> Array:
	var pattern: Array = []
	pattern.append(clicked_tile)
	var pattern_index: int = 0
	while len(pattern) < 6:
		var surrounding_cells: Array = map.get_surrounding_cells(pattern[pattern_index])
		for i in range(len(surrounding_cells)):
			var tile_data_pattern: TileData = map.get_cell_tile_data(0, surrounding_cells[i])
			if (
				tile_data_pattern.get_custom_data("clickable")
				and !pattern.has(surrounding_cells[i])
			):
				pattern.append(surrounding_cells[i])
		pattern_index += 1
	return pattern


# Function: _physics_process
# Description: Updates the player's movement and performs a free field distance check.
# Sets the last player position for reference.
func _physics_process(delta):
	player_movement()
	MovementLoop(delta)
	free_field_distance_check()
	DataScript.set_last_player_position(position)


# Function: free_field_distance_check
# Description: Checks if the player is close to a free field, opens the menu if conditions are met,
# and resets the free field pressed state. Otherwise, sets the pattern for movement.
func free_field_distance_check():
	if free_field_pressed:
		if (
			(position.distance_to(clicked_tile_center) < 35 or stand_still)
			and free_field_pattern.has(clicked_tile)
		):
			moving = false
			stand_still = true
			open_inventory(clicked_tile_center)
			free_field_pressed = false
		else:
			stand_still = false
			set_pattern()


# Function: open_inventory
# Description: Opens the menu based on the provided value, which represents a position.
# Retrieves the field and building indices, and if there is no building at the location,
# opens the inventory menu.
func open_inventory(value):
	fieldIndex = getFieldIndex(value)
	buildingIndex = getBuildingIndex(fieldIndex)[0]
	print(fieldIndex)
	if buildingIndex == -1:
		DataScript.is_in_building_menu = true
		$Camera2D/HUD/showMap.visible = false
		$Camera2D/HUD/RessourceBar.visible = false
		$Camera2D/HUD/Inventory.set_inventory()
		$Camera2D/HUD/Inventory.visible = true


# Function: place_building
# Description: Places a building at the specified field index and updates the inventory.
# Hides the inventory menu after placing the building and updates the maximum resources.
func place_building(bIndex: int):
	DataScript.is_in_building_menu = false
	$Camera2D/HUD/Inventory.visible = false
	reset_camera()
	DataScript.set_building(fieldIndex, DataScript.inventory[bIndex])
	DataScript.inventory.remove_at(bIndex)
	DataScript.set_max_ressources()
	DataScript.update_storage_building_capacity()


# Function: MovementLoop
# Description: Handles movement based on navigation and animation parameters.
# The character accelerates towards the target position, moves along the navigation path,
# and updates the animation state accordingly.
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


# Function: getFieldIndex
# Description: Returns the field index based on the provided coordinates.
# Returns -1 if the coordinates do not correspond to any field.
func getFieldIndex(value):
	if value.x >= 16 && value.x <= 80:
		if value.y >= 144 && value.y <= 176:
			return 0
	if value.x >= 144 && value.x <= 208:
		if value.y >= 48 && value.y <= 80:
			return 1
	if value.x >= 528 && value.x <= 592:
		if value.y >= 48 && value.y <= 80:
			return 2
	if value.x >= 496 && value.x <= 560:
		if value.y >= -144 && value.y <= -112:
			return 3
	if value.x >= 208 && value.x <= 272:
		if value.y >= -144 && value.y <= -112:
			return 4
	if value.x >= -144 && value.x <= -80:
		if value.y >= -144 && value.y <= -112:
			return 5
	if value.x >= -496 && value.x <= -432:
		if value.y >= -80 && value.y <= -48:
			return 6
	if value.x >= -304 && value.x <= -240:
		if value.y >= 80 && value.y <= 112:
			return 7
	if value.x >= -176 && value.x <= -112:
		if value.y >= 240 && value.y <= 272:
			return 8
	if value.x >= -368 && value.x <= -304:
		if value.y >= 336 && value.y <= 368:
			return 9
	if value.x >= 48 && value.x <= 112:
		if value.y >= 368 && value.y <= 400:
			return 10
	if value.x >= 336 && value.x <= 400:
		if value.y >= 432 && value.y <= 464:
			return 11
	if value.x >= 432 && value.x <= 496:
		if value.y >= 240 && value.y <= 272:
			return 12
	if value.x >= 880 && value.x <= 944:
		if value.y >= 240 && value.y <= 272:
			return 13
	return -1


# Function: getBuildingIndex
# Description: Returns the building index from the fieldArray based on the provided value.
func getBuildingIndex(value):
	return DataScript.fieldArray[value]


func _on_showMap_button_pressed():
	mapShowPressed = not mapShowPressed
	if mapShowPressed:
		mapButton.texture_normal = exitMapTexture
		resourceBar.visible = false
		self.modulate = Color.RED
		camera.zoom = Vector2(0.18, 0.2)
		camera.position = Vector2(248, 160) - self.position
	else:
		reset_camera()
