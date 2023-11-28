extends CharacterBody2D


var max_speed = 100
var speed = 0
var acceleration = 400
var move_direction
var moving = false
var destination = Vector2()
var movement = Vector2()

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var optionBar = $"Camera2D/Building Options"
@onready var infoScreen = $"Camera2D/Info Screen2"
@onready var nav : NavigationAgent2D = $NavigationAgent2D


func _unhandled_input(event):
	if event.is_action_pressed('Click'):
		moving = true
		nav.target_position = get_global_mouse_position()
		animationState.travel("Run")


func _physics_process(delta):
	
	MovementLoop(delta)
	

func MovementLoop(delta):
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
	if position.distance_to(nav.target_position) > 20:
		animationTree.set("parameters/Idle/blend_position", movement)
		animationTree.set("parameters/Run/blend_position", movement)

		velocity = velocity.lerp(move_direction * speed, speed * delta)
		move_and_slide()
	else:
		moving = false
	
func show_options(path : String):
	if optionBar:
		optionBar.show()
		optionBar.set_miniGame(path)
	else:
		print("optionBar is null!")
	#optionBar.set_miniGame(path)
	
func hide_options():
	if optionBar:
		optionBar.hide()
	else:
		print("optionBar is null!")
	
	

