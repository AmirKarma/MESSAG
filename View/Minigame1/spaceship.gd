# Spaceship script

class_name spaceship extends CharacterBody2D

# Signals for communication with other nodes
signal cannon_shot(shot)
signal player_dead

# Exported variables for easy tweaking in the editor
@export var player_speed = 50
@export var shot_rate := 0.25

# References to scene elements using the @onready keyword
@onready var Gun = $Gun
@onready var sprite = $Sprite2D
@onready var collision = $CollisionPolygon2D
var timer1

# Preloaded scene for bullets
var shot_scene = preload("res://Minigame1/bullet.tscn")

# Variables for controlling shooting
var shot_cooldown := false
var alive := true

# Exported variables for spaceship movement
@export var movement_speed := 2.5
@export var max_speed := 100.0
@export var rotation_speed := 250.0
@export var float_effect := 0.5

# Called when the node is added to the scene
func _ready():
	# Timer for controlling respawn
	timer1 = Timer.new()
	add_child(timer1)
	timer1.wait_time = 3

# Process function for handling user input
func _process(delta):
	if Input.is_action_pressed("schuss"):
		
		if !shot_cooldown:
			shot_cooldown = true 
			shoot()
			await get_tree().create_timer(shot_rate).timeout
			shot_cooldown = false

# Physics process function for handling movement
func _physics_process(delta):
	var direction = Vector2(0, Input.get_axis("vor", "zurueck"))
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
	var screen_size = get_viewport_rect().size
	if global_position.y < 0:
		global_position.y = screen_size.y
		
	elif global_position.y > screen_size.y:
		global_position.y = 0    
	
	if global_position.x < 0:
		global_position.x = screen_size.x
		
	elif global_position.x > screen_size.x:
		global_position.x = 0    

# Respawn function
func respawn(pos):
	if alive == false:
		alive = true
		global_position = pos
		velocity = Vector2.ZERO
		sprite.visible = true
		timer1.start()
		timer1.timeout.connect(playerCollisionRespawn)

# Function to handle respawn after a collision
func playerCollisionRespawn():
	collision.set_deferred("disabled", false)
	process_mode = Node.PROCESS_MODE_INHERIT
	print("Respawn")

# Function to handle player death
func dead():
	if alive == true:
		alive = false
		sprite.visible = false
		collision.set_deferred("disabled", true)
		emit_signal("player_dead")    

# Function to handle shooting
func shoot():
	if alive:
		var shot_instance = shot_scene.instantiate()
		shot_instance.global_position = Gun.global_position
		shot_instance.rotation = rotation
		emit_signal("cannon_shot", shot_instance)
