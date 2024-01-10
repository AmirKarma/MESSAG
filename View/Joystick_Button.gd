extends Sprite2D

@onready var parent = $".."

# Variable for the pressed button
var pressed = false

# Variables for the current directions
var links : bool = false
var rechts : bool = false
var vor : bool = false
var zurueck : bool = false

# Export variables which hold the values for the maximum length and the dead zone.
@export var maxlength= 23
@export var deadzone= 5

# Function: _ready
# Description: Initializes the node. Adjusts 'maxlength' based on parent scale.
func _ready():
	maxlength *= 10* parent.scale.x

# Function: _process
# Description: Handles the process logic for the node.
# If 'pressed' is true, updates the global position based on mouse movement.
# Handles input actions for different directions.
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
		Input.action_release("links")
		Input.action_release("rechts")
		Input.action_release("vor")
		Input.action_release("zurueck")

# Function: _on_button_button_down
# Description: Called when the button is pressed. Sets 'pressed' to true.
func _on_button_button_down():
	pressed = true
	
# Function: _on_button_button_up
# Description: Called when the button is released. Sets 'pressed' to false.
func _on_button_button_up():
	pressed = false

# Function: _on_links_mouse_entered
# Description: Called when the mouse enters the "links" area. 
# Sets the 'links' variable to true.
func _on_links_mouse_entered():
	links = true

# Function: _on_links_mouse_exited
# Description: Called when the mouse exits the "links" area. 
# Sets the 'links' variable to false.
func _on_links_mouse_exited():
	links= false

# Function: _on_rechts_mouse_entered
# Description: Called when the mouse enters the "rechts" area. 
# Sets the 'rechts' variable to true.
func _on_rechts_mouse_entered():
	rechts = true
	
# Function: _on_rechts_mouse_exited
# Description: Called when the mouse exits the "rechts" area. 
# Sets the 'rechts' variable to false.
func _on_rechts_mouse_exited():
	rechts = false

# Function: _on_vor_mouse_entered
# Description: Called when the mouse enters the "vor" area. 
# Sets the 'vor' variable to true.
func _on_vor_mouse_entered():
	vor = true
	
# Function: _on_vor_mouse_exited
# Description: Called when the mouse exits the "vor" area. 
# Sets the 'vor' variable to false.
func _on_vor_mouse_exited():
	vor = false

# Function: _on_zurück_mouse_entered
# Description: Called when the mouse enters the "zurück" area. 
# Sets the 'zurueck' variable to true.
func _on_zurück_mouse_entered():
	zurueck = true
	
# Function: _on_zurück_mouse_exited
# Description: Called when the mouse exits the "zurück" area. 
# Sets the 'zurueck' variable to false.
func _on_zurück_mouse_exited():
	zurueck = false


