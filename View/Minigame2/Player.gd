extends CharacterBody2D


const first_lane = 64
const last_lane = 256

const lane_length = 64

#var speed_limit = 500
func _ready():
	global_position.x = first_lane
	global_position.y = get_viewport_rect().size.y - 20

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_left"):
		if global_position.x != first_lane:
			global_position.x -= lane_length
	elif Input.is_action_just_pressed("ui_right"):
		if global_position.x != last_lane:
			global_position.x += lane_length

	move_and_slide()
