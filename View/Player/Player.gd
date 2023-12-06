extends CharacterBody2D

var max_speed = 100
var speed = 0
var acceleration = 400
var move_direction
var moving = false
var destination = Vector2()
var movement = Vector2()
var free_field_pressed:bool = false
var stand_still:bool = false
var clicked_tile
var clicked_tile_center
var tile_data
var free_field_pattern:Array

@onready var world : Node2D = get_tree().get_root().get_node("World")
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var nav : NavigationAgent2D = $NavigationAgent2D
@onready var map : TileMap = world.get_node('TileMap')

func _unhandled_input(event):
	if event.is_action_pressed('Click'):
		set_free_field_pressed()
		free_field_distance_check()
		if !stand_still:
			set_patter()
			moving = true
			nav.target_position = get_global_mouse_position()
			animationState.travel("Run")

func set_patter():
	if tile_data.get_custom_data('clickable'):
			free_field_pattern = create_pattern()

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
	
func _physics_process(delta):
	MovementLoop(delta)
	free_field_distance_check()

func free_field_distance_check():
	if free_field_pressed:
		if (position.distance_to(clicked_tile_center) < 35 or stand_still) and free_field_pattern.has(clicked_tile):
			moving = false
			stand_still = true
			open_menu()
			free_field_pressed = false
		else :
			stand_still = false
			set_patter()

func open_menu():
	print("open")

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

