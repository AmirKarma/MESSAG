# Bullet script

extends Area2D

# Exported variable for bullet speed
@export var shot_speed: int = 500

# Movement vector for the bullet
var movement_vector: Vector2 = Vector2(0, -1)


# Physics process function for handling movement
func _physics_process(delta):
	global_position += movement_vector.rotated(rotation) * shot_speed * delta


# Function called when the bullet exits the screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


# Function called when the bullet enters an area
func _on_area_entered(area):
	print(area)
	if area is Comet:
		area.destruction()  # Call the destruction function of the comet
		queue_free()  # Queue the bullet for removal
	#pass
