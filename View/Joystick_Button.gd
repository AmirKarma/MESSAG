extends Sprite2D

@onready var parent = $".."
var pressed = false

var links = false
var rechts = false
var vor = false
var zurueck = false

@export var maxlength= 23
@export var deadzone= 5

# Called when the node enters the scene tree for the first time.
func _ready():
	maxlength *= 10* parent.scale.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pressed:
		if get_global_mouse_position().distance_to(parent.global_position) <= maxlength:
			global_position = get_global_mouse_position()
		else:
			var angle = parent.global_position.angle_to_point(get_global_mouse_position())
			
		
		if links:
			Input.action_press("links")
		else:
			Input.action_release("links")
		if rechts:
			Input.action_press("rechts")
		else:
			Input.action_release("rechts")
		if vor:
			Input.action_press("vor")
		else:
			Input.action_release("vor")	
		if zurueck:
			Input.action_press("zurueck")
		else:
			Input.action_release("zurueck")		
			
	else:
		global_position = lerp(global_position, parent.global_position, delta*10)


func _on_button_button_down():
	pressed = true
	
	
func _on_button_button_up():
	pressed = false



func _on_button_2_mouse_entered():
	links = true
func _on_button_2_mouse_exited():
	links= false

func _on_rechts_mouse_entered():
	rechts = true
func _on_rechts_mouse_exited():
	rechts = false

func _on_vor_mouse_entered():
	vor = true
func _on_vor_mouse_exited():
	vor = false


func _on_zurück_mouse_entered():
	zurueck = true
func _on_zurück_mouse_exited():
	zurueck = false
