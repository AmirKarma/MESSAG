extends Node2D

# Random number generator for generating random values
var random = RandomNumberGenerator.new()

# Array of scene paths to different object types
var scene = [
	preload("res://Minigame2/Objects/object_1.tscn"),
	preload("res://Minigame2/Objects/object_2.tscn"),
	preload("res://Minigame2/Objects/object_3.tscn")
]

# Array of possible x-values for object spawn positions
var xValues = [64, 128, 192, 256]

# Array of possible comet speed values
var cometSpeedValues = [Vector2(0, 40), Vector2(0, 50), Vector2(0, 30), Vector2(0, 20)]

# Reference to the onready node for the HUD overlay
@onready var overlay = $Hud/Overlay

# Array to store instances of spawned objects
var objects:Array = []

# Array to store corresponding comet speeds for each object
var cometSpeed = []

# Variable to determine the number of objects to spawn
var cometSpawnCount

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize timer, score, and spawn count
	DataScript.minigame2_timer = 3
	DataScript.minigame2_score = 0
	cometSpawnCount = 1

	# Initialize HUD overlay score display
	overlay.score = 0

	# Spawn initial set of objects
	spawn_objects()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta): 
	set_score()
	move_objects(delta)

# Function to move the objects and handle object spawning and removal
func move_objects(delta):
	for object in len(objects):
		# Move objects based on their individual speeds
		objects[object].position += delta * cometSpeed[object] 

	# Check if objects are out of the viewport, remove them, and spawn new ones
	if !objects.is_empty():
		var objectLength = len(objects)
		var object = 0
		while object < objectLength:
			if objects[object].position.y > get_viewport_rect().size.y + 50:
				remove_objects(object)
				objectLength -= 1
				object -= 1
			object += 1
	else:
		spawn_objects()

# Function to update the HUD overlay score display
func set_score():
	overlay.score = DataScript.minigame2_score

# Function to spawn a random number of objects with random positions and speeds
func spawn_objects():
	var xValues_copy = xValues.duplicate(true)
	var number_of_objects = random.randi_range(cometSpawnCount, 3)
	
	for object in number_of_objects:
		# Instantiate objects and set their properties
		objects.append(scene[object].instantiate())
		# Generate the CometSpeed for a single Comet
		var singleCometSpeed = cometSpeedValues[randi() % len(cometSpeedValues)] * DataScript.minigame2_timer
		cometSpeed.append(singleCometSpeed)
		# Spawn the comet at a random position
		var spawnX = xValues_copy[randi() % len(xValues_copy)]
		xValues_copy.remove_at(xValues_copy.find(spawnX))
		
		objects[object].position = Vector2(spawnX, -200)
		$Objects.add_child(objects[object])

# Function to remove an object from the scene and corresponding arrays
func remove_objects(object):
	$Objects.remove_child(objects[object])
	objects.remove_at(object)
	cometSpeed.remove_at(object)

# Timer timeout function to modify game parameters over time
func _on_timer_timeout():
	print(DataScript.minigame2_timer)
	match str(DataScript.minigame2_timer).pad_decimals(0):
		'4':
			DataScript.minigame2_timerSpeed = 0.005 
			remove_comet_speed(3)
		'5': 
			DataScript.minigame2_timerSpeed  = 0.0025 
			cometSpawnCount = 2
		'6': 
			DataScript.minigame2_timerSpeed  = 0.00125 
			remove_comet_speed(2)
		'7':
			remove_comet_speed(1)
			cometSpawnCount = 3
		
	DataScript.minigame2_timer += DataScript.minigame2_timerSpeed

# Function to remove a comet speed value at a given index
func remove_comet_speed(index):
	if len(cometSpeedValues) > index:
		cometSpeedValues.remove_at(index)
