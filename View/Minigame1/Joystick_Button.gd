extends Sprite2D

@onready var parent = $".."
var pressed = false


@export var maxlength= 23
@export var deadzone= 5


# Called when the node enters the scene tree for the first time.
func _ready():
	maxlength *= 15 * parent.scale.x



# Called every frame. 'delta' is the elapsed time since the previous frame.
# Checking Joystick Position and does Spaceship Interaction
func _process(delta):
	
	if pressed:
		if get_global_mouse_position().distance_to(parent.global_position) <= maxlength:
			global_position = get_global_mouse_position()
		else:
			pass
			#var angle = parent.global_position.angle_to_point(get_global_mouse_position())
			
		Input.is_action_pressed("links")
		Input.is_action_pressed("rechts")
		Input.is_action_pressed("vor")
		Input.is_action_pressed("zurueck")
		
		if(global_position.y < 122 && global_position.x > 274):
			Input.action_press("vor")
			Input.action_press("rechts")
			Input.action_release("zurueck")
			Input.action_release("links")
		elif(global_position.y < 122 && global_position.x < 260):
			Input.action_press("vor")
			Input.action_press("links")
			Input.action_release("zurueck")
			Input.action_release("rechts")
		elif(global_position.y > 135 && global_position.x < 260):
			Input.action_press("zurueck")
			Input.action_press("links")
			Input.action_release("vor")
			Input.action_release("rechts")
		elif(global_position.y > 135 && global_position.x > 274):
			Input.action_press("zurueck")
			Input.action_press("rechts")
			Input.action_release("vor")
			Input.action_release("links")
		elif(global_position.y < 122):
			Input.action_press("vor")
			Input.action_release("rechts")
			Input.action_release("zurueck")
			Input.action_release("links")
		elif(global_position.y > 135):
			Input.action_press("zurueck")
			Input.action_release("rechts")
			Input.action_release("vor")
			Input.action_release("links")
		elif(global_position.x < 260):
			Input.action_press("links")
			Input.action_release("rechts")
			Input.action_release("vor")
			Input.action_release("zurueck")
		elif(global_position.x > 274):
			Input.action_press("rechts")
			Input.action_release("links")
			Input.action_release("vor")
			Input.action_release("zurueck")			
			
	else:
		global_position = lerp(global_position, parent.global_position, delta*10)
		Input.action_release("links")
		Input.action_release("rechts")
		Input.action_release("vor")
		Input.action_release("zurueck")


func _on_touch_on_off_button_down():
	pressed = true
	
func _on_touch_on_off_button_up():
	pressed = false

