class_name raumschiff extends CharacterBody2D

signal kanonen_schuss(schuss)
signal spieler_tot

@export var speedplayer = 50
@export var schuss_rate := 0.25

@onready var Gun = $Gun
@onready var sprite = $Sprite2D
@onready var collision = $CollisionPolygon2D

var shot_szene = preload("res://Minigame1/schuss.tscn")

var shot_cooldown := false
var alive := true


@export var movementspeed := 2.5
@export var maxspeed := 100.0
@export var rotation_speed := 250.0
@export var schwebeeffect := 0.5
 


func _process(delta):
	if Input.is_action_pressed("schuss"):
		if !shot_cooldown:
			shot_cooldown = true 
			schuss()
			await get_tree().create_timer(schuss_rate).timeout
			shot_cooldown = false

func _physics_process(delta):
	
		var direction = Vector2(0, Input.get_axis("vor", "zurueck"))
		velocity += direction.rotated(rotation) * movementspeed
		velocity = velocity.limit_length(maxspeed)
		
		if direction.y == 0:
			velocity = velocity.move_toward(Vector2.ZERO,schwebeeffect)
			
		if Input.is_action_pressed("rechts"):
			rotate(deg_to_rad(rotation_speed * delta))
		
		if Input.is_action_pressed("links"):
			rotate(deg_to_rad(-rotation_speed * delta))
			
		
		move_and_slide()
		
		
		var screen_size = get_viewport_rect().size
		if global_position.y < 0:
			global_position.y = screen_size.y
			
		elif global_position.y > screen_size.y:
			global_position.y = 0	
		
		if global_position.x < 0:
			global_position.x = screen_size.x
			
		elif global_position.x > screen_size.x:
			global_position.x = 0	
			
func respawn(pos):
	if alive ==false:
		alive = true
		global_position = pos
		velocity = Vector2.ZERO
		sprite.visible = true
		collision.set_deferred("disabled", false)
		process_mode = Node.PROCESS_MODE_INHERIT
		print("Respawn")

func tot():
	if alive == true:
		alive = false
		sprite.visible = false
		collision.set_deferred("disabled", true)
		emit_signal("spieler_tot")		
	
		
func schuss():
	var k = shot_szene.instantiate()
	k.global_position = Gun.global_position
	k.rotation = rotation
	emit_signal("kanonen_schuss", k)
	

