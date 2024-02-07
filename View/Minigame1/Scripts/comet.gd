# This script defines the behavior of comets in the game.

class_name Comet extends Area2D

## Signal emitted when the comet is destroyed. Carries information about the position, size, and points awarded.
signal destroyed(position, size)

## Enumerates the possible sizes of comets: LARGE, MEDIUM, SMALL.
enum CometSize { LARGE, MEDIUM, SMALL }


## Represents the size of the comet.
@export var size: int = CometSize.LARGE


## Represents the direction of movement for the comet.
var movement_vector: Vector2 = Vector2(0, -1)


## Represents the speed of the comet.
var comet_speed: float = 30


## Represents the speed range for large comets.
var comet_speed_large: float = randf_range(20, 30)


## Represents the speed range for medium-sized comets.
var comet_speed_medium: float = randf_range(35, 45)


## Represents the speed range for small comets.
var comet_speed_small: float = randf_range(50, 60)


## Represents the points awarded for destroying the comet based on its size.
var points: int:
	get:
		match size:
			CometSize.LARGE:
				return 10
			CometSize.MEDIUM:
				return 15
			CometSize.SMALL:
				return 25
			_:
				return 0

# Reference to the comet's sprite and hitbox
@onready var comet_sprite: Sprite2D = $Sprite2D
@onready var comet_hitbox: CollisionShape2D = $CollisionShape2D

# Function: _ready
## Called when the node is added to the scene. Initializes properties and sets sprite textures based on comet size.
func _ready():
	rotation = randf_range(0, 2 * PI)

	match size:
		CometSize.LARGE:
			comet_speed = comet_speed_large
			comet_sprite.texture = preload("res://Minigame1/Assets/chunks_big.png")
			comet_sprite.scale = Vector2(0.5, 0.5)

		CometSize.MEDIUM:
			comet_sprite.texture = preload("res://Minigame1/Assets/chunks_middle.png")
			comet_hitbox.set_deferred(
				"shape", preload("res://Minigame1/Assets/chunks_middle.tres")
			)
			comet_sprite.scale = Vector2(0.5, 0.5)
			comet_speed = comet_speed_medium
		CometSize.SMALL:
			comet_speed = comet_speed_small
			comet_sprite.texture = preload("res://Minigame1/Assets/chunks_small.png")
			comet_sprite.scale = Vector2(0.3, 0.3)
			comet_hitbox.set_deferred(
				"shape", preload("res://Minigame1/Assets/chunks_small.tres")
			)

# Function: _physics_process
## Handles the movement of the comet.
func _physics_process(delta):
	global_position += delta * movement_vector.rotated(rotation) * comet_speed

	var comet_radius: float = comet_hitbox.shape.radius
	var screen_size: Vector2 = get_viewport_rect().size
	if global_position.y + comet_radius < 0:
		global_position.y = screen_size.y + comet_radius

	elif global_position.y - comet_radius > screen_size.y:
		global_position.y = -comet_radius

	if global_position.x + comet_radius < 0:
		global_position.x = screen_size.x + comet_radius

	elif global_position.x - comet_radius > screen_size.x:
		global_position.x = -comet_radius

# Function: _on_body_entered
## Called when the body enters the comet's area. If the body is a spaceship, the spaceship is destroyed.
func _on_body_entered(body):
	if body is spaceship:
		var spaceship: spaceship = body
		spaceship.dead()

# Function: destruction
## Called for comet destruction. Emits the "destroyed" signal and removes the comet from the scene.
func destruction():
	emit_signal("destroyed", global_position, size, points)
	queue_free()
