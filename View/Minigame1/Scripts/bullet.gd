## This script defines the behavior of a bullet projectile in the game.

extends Area2D

# Variable: shot_speed
## Determines the speed of the bullet.
@export var shot_speed: int = 500

# Variable: movement_vector
## Represents the direction of movement for the bullet.
var movement_vector: Vector2 = Vector2(0, -1)

# Function: _physics_process
## Handles the movement of the bullet based on its speed and direction.
func _physics_process(delta):
	global_position += movement_vector.rotated(rotation) * shot_speed * delta

# Function: _on_visible_on_screen_notifier_2d_screen_exited
## Called when the bullet exits the screen. Removes the bullet from the scene.
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

# Function: _on_area_entered
## Called when the bullet enters another area (e.g., a Comet). Destroys the comet and removes the bullet.
func _on_area_entered(area):
	if area is Comet:
		area.destruction()  # Call the destruction function of the comet
		queue_free()  # Queue the bullet for removal
