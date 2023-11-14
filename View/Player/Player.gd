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



func _unhandled_input(event):
	if event.is_action_pressed('Click'):
		moving = true
		destination = get_global_mouse_position()
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
	movement = position.direction_to(destination) * speed
	move_direction = rad_to_deg(destination.angle_to_point(position))
	if position.distance_to(destination) > 5:
		animationTree.set("parameters/Idle/blend_position", movement)
		animationTree.set("parameters/Run/blend_position", movement)

		velocity = movement
		move_and_slide()
	else:
		moving = false
		

