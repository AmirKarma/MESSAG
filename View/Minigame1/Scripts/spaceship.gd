## This script defines the behavior of a spaceship in the game.

class_name spaceship extends CharacterBody2D

## Signal for communication with other nodes
signal cannon_shot(shot)

## Signal for communication with other nodes
signal player_dead

## Exported variable for adjusting the player's speed in the editor
@export var player_speed: float = 50

## Exported variable for adjusting the rate of shooting in the editor
@export var shot_rate: float = 0.25

## Exported variable for adjusting the movement speed in the editor
@export var movement_speed: float = 2.5

## Exported variable for adjusting the maximum speed in the editor
@export var max_speed: float = 100.0

## Exported variable for adjusting the rotation speed in the editor
@export var rotation_speed: float = 250.0

## Exported variable for adjusting the floating effect in the editor
@export var float_effect: float = 0.5

## Timer for managing shooting cooldown
var timer1: Timer

## Preloaded scene for bullets
var shot_scene: PackedScene = preload("res://Minigame1/Scenes/bullet.tscn")

## Variable for controlling shooting cooldown
var shot_cooldown: bool = false

## Variable representing player status
var alive: bool = true

## Reference to the Gun node using the @onready keyword
@onready var Gun: Node = $Gun

## Reference to the sprite node using the @onready keyword
@onready var sprite: Sprite2D = $Sprite2D

## Reference to the collision node using the @onready keyword
@onready var collision: CollisionPolygon2D = $CollisionPolygon2D


## Called when the node is added to the scene
func _ready():
	# Timer for controlling respawn
	timer1 = Timer.new()
	add_child(timer1)
	timer1.wait_time = 3
	timer1.timeout.connect(playerCollisionRespawn)


## Process function for handling user input
func _process(_delta):
	if Input.is_action_pressed("schuss"):
		if !shot_cooldown:
			shot_cooldown = true
			shoot()
			await get_tree().create_timer(shot_rate).timeout
			shot_cooldown = false


## Physics process function for handling movement
func _physics_process(delta):
	var direction: Vector2 = Vector2(0, Input.get_axis("vor", "zurueck"))
	velocity += direction.rotated(rotation) * movement_speed
	velocity = velocity.limit_length(max_speed)

	if direction.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, float_effect)

	if Input.is_action_pressed("rechts"):
		rotate(deg_to_rad(rotation_speed * delta))

	if Input.is_action_pressed("links"):
		rotate(deg_to_rad(-rotation_speed * delta))

	move_and_slide()

	# Screen wrapping
	var screen_size: Vector2 = get_viewport_rect().size
	if global_position.y < 0:
		global_position.y = screen_size.y

	elif global_position.y > screen_size.y:
		global_position.y = 0

	if global_position.x < 0:
		global_position.x = screen_size.x

	elif global_position.x > screen_size.x:
		global_position.x = 0


## Function to handle respawn after a collision
func playerCollisionRespawn():
	collision.set_deferred("disabled", false)
	process_mode = Node.PROCESS_MODE_INHERIT


## Function to handle player death
func dead():
	if alive == true:
		alive = false
		sprite.visible = false
		collision.set_deferred("disabled", true)
		emit_signal("player_dead")

		
## Respawn function
func respawn(pos):
	if alive == false:
		alive = true
		global_position = pos
		velocity = Vector2.ZERO
		sprite.visible = true
		timer1.start()		

## Function to handle shooting
func shoot():
	if alive:
		var shot_instance: Node = shot_scene.instantiate()
		shot_instance.global_position = Gun.global_position
		shot_instance.rotation = rotation
		emit_signal("cannon_shot", shot_instance)

