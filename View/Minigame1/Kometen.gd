class_name Kometen extends Area2D

signal zerstört(position, groesse)

var bewegungs_vector := Vector2(0, -1)
var komet_geschw := 30
var komet_geschw_gross = randf_range(20,30)
var komet_geschw_mittel = randf_range(35,45)
var komet_geschw_klein = randf_range(50,60)

@onready var komet = $Sprite2D
@onready var kometenhitbox = $CollisionShape2D


enum KometenGroesse{GROSS, MITTEL, KLEIN}
@export var size := KometenGroesse.GROSS



func _ready():
	rotation = randf_range(0, 2*PI) #Kann sich in alle Richtungen drehen 
	
	match size:
		KometenGroesse.GROSS:
			komet_geschw = komet_geschw_gross
			komet.texture = preload("res://Minigame1/KometB.png")
			
			
		KometenGroesse.MITTEL:
			komet.texture = preload("res://Minigame1/KometM.png")
			kometenhitbox.set_deferred("shape", preload("res://Minigame1/Resourcen/kometen_mittel.tres"))
			komet_geschw = komet_geschw_mittel
		KometenGroesse.KLEIN:
			komet_geschw = komet_geschw_klein
			komet.texture = preload("res://Minigame1/KometK.png")
			kometenhitbox.set_deferred("shape", preload("res://Minigame1/Resourcen/kometen_klein.tres"))
		

func _physics_process(delta):
	global_position += delta* bewegungs_vector.rotated(rotation) * komet_geschw
	
	var kometen_radius = kometenhitbox.shape.radius
	var screen_size = get_viewport_rect().size
	if global_position.y+kometen_radius < 0:
		global_position.y = screen_size.y+kometen_radius
			
	elif global_position.y-kometen_radius > screen_size.y:
		global_position.y = -kometen_radius	
		
	if global_position.x + kometen_radius < 0:
		global_position.x = screen_size.x+kometen_radius
			
	elif global_position.x-kometen_radius > screen_size.x:
		global_position.x = -kometen_radius
		
		
func zerstörung():
	emit_signal("zerstört", global_position, size)	
	queue_free()

