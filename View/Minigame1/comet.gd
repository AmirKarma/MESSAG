class_name Comet extends Area2D

signal destroyed(position, size)

var movement_vector := Vector2(0, -1)
var comet_speed := 30
var comet_speed_large = randf_range(20,30)
var comet_speed_medium = randf_range(35,45)
var comet_speed_small = randf_range(50,60)

@onready var comet_sprite = $Sprite2D
@onready var comet_hitbox = $CollisionShape2D

enum CometSize{LARGE, MEDIUM, SMALL}
@export var size := CometSize.LARGE

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

func _ready():
	rotation = randf_range(0, 2*PI)
	
	match size:
		CometSize.LARGE:
			comet_speed = comet_speed_large
			comet_sprite.texture = preload("res://Minigame1/chunks_big.png")
			comet_sprite.scale = Vector2(0.5,0.5)
			
		CometSize.MEDIUM:
			comet_sprite.texture = preload("res://Minigame1/chunks_middle.png")
			comet_hitbox.set_deferred("shape", preload("res://Minigame1/Resourcen/chunks_middle.tres"))
			comet_sprite.scale = Vector2(0.5,0.5)
			comet_speed = comet_speed_medium
		CometSize.SMALL:
			comet_speed = comet_speed_small
			comet_sprite.texture = preload("res://Minigame1/chunks_small.png")
			comet_sprite.scale = Vector2(0.3,0.3)
			comet_hitbox.set_deferred("shape", preload("res://Minigame1/Resourcen/chunks_small.tres"))

func _physics_process(delta):
	global_position += delta * movement_vector.rotated(rotation) * comet_speed
	
	var comet_radius = comet_hitbox.shape.radius
	var screen_size = get_viewport_rect().size
	if global_position.y + comet_radius < 0:
		global_position.y = screen_size.y + comet_radius
			
	elif global_position.y - comet_radius > screen_size.y:
		global_position.y = -comet_radius	
		
	if global_position.x + comet_radius < 0:
		global_position.x = screen_size.x + comet_radius
			
	elif global_position.x - comet_radius > screen_size.x:
		global_position.x = -comet_radius

func destruction():
	emit_signal("destroyed", global_position, size, points)	
	queue_free()

func _on_body_entered(body):
	if body is spaceship:
		var spaceship = body
		spaceship.dead()
