extends Node2D

# Random number generator for generating random values
var random: RandomNumberGenerator = RandomNumberGenerator.new()

# Array of scene paths to different enemy types
var enemy_path: PackedScene = preload("res://Minigame2/Scenes/enemy.tscn")

# Array of possible x-values for enemy spawn positions
var x_values: Array = [64, 128, 192, 256]

# Array of possible comet speed values
var comet_speed_values: Array = [Vector2(0, 50), Vector2(0, 40), Vector2(0, 30), Vector2(0, 20)]

# Reference to the onready node for the HUD overlay
@onready var overlay: Node = $Hud/Overlay

# Array to store instances of spawned enemies
var spawned_enemies: Array = []

# Array to store corresponding comet speeds for each enemy
var comet_speed: Array = []

# Variable to determine the number of enemies to spawn
var comet_spawn_count: int


# Called when the node enters the scene tree for the first time.
# Function: _ready
# Description: Called when the node enters the scene tree for the first time.
# Initializes timer, score, spawn count, HUD overlay score display, and spawns the initial set of enemies.
func _ready():
	# Initialize timer, score, and spawn count in DataScript
	DataScript.minigame2_timer = 3
	DataScript.minigame2_score = 0
	DataScript.minigame2_timerSpeed = 0.01
	comet_spawn_count = 1

	# Initialize HUD overlay score display
	overlay.score = 0

	# Spawn the initial set of enemies
	spawn_enemies()


# Function: _process
# Description: Called every frame. 'delta' is the elapsed time since the previous frame.
# Updates the HUD overlay score display and moves/manages enemies in the scene.
func _process(delta):
	# Update the HUD overlay score display
	set_score()

	# Move and manage enemies
	move_enemies(delta)


# Function: move_enemies
# Description: Moves enemies based on their individual speeds and checks if they are out of the viewport.
# Removes enemies that are out of the viewport and spawns new ones as needed.
func move_enemies(delta):
	for enemy in spawned_enemies:
		# Move enemies based on their individual speeds
		enemy.position += delta * comet_speed[spawned_enemies.find(enemy)]

	# Iterate through a copy of the spawned enemies list to avoid modifying it during iteration.
	for enemy in spawned_enemies.duplicate():
		# Check if the y-position of the enemy is beyond the viewport plus an offset of 50.
		if enemy.position.y > get_viewport_rect().size.y + 50:
			# Remove the enemy if it has moved out of the viewport.
			remove_enemies(enemy)

	# Check if the spawned_enemies list is empty.
	if spawned_enemies.is_empty():
		# If the list is empty, spawn a new set of enemies.
		spawn_enemies()


# Function: set_score
# Description: Updates the HUD overlay score display using the score from DataScript.
func set_score():
	overlay.score = DataScript.getMinigame2_score()


# Function: spawn_enemies
# Description: Spawns a random number of enemies with random positions and speeds.
func spawn_enemies():
	var x_values_copy: Array = x_values.duplicate(true)
	var number_of_enemies: int = random.randi_range(comet_spawn_count, 3)

	# Iterate to spawn the specified number of enemies.
	for _filler in range(number_of_enemies):
		# Instantiate the enemy from the chosen scene path.
		var enemy: Node = enemy_path.instantiate()

		# Generate a random speed for the comet and adjust it based on the game timer.
		var single_comet_speed: Vector2 = (
			comet_speed_values[random.randi() % len(comet_speed_values)]
			* DataScript.minigame2_timer
		)

		# Append the comet speed to the comet_speed array.
		comet_speed.append(single_comet_speed)

		# Choose a random x-position for the enemy and remove that x-value from the copy.
		var spawn_x: int = x_values_copy[random.randi() % len(x_values_copy)]
		x_values_copy.erase(spawn_x)

		# Set the initial position of the enemy.
		enemy.position = Vector2(spawn_x, -200)

		# Add the enemy as a child to the 'Enemies' node.
		$Enemies.add_child(enemy)

		# Append the spawned enemy to the spawned_enemies array.
		spawned_enemies.append(enemy)


# Function: remove_enemies
# Description: Removes an enemy from the scene and its corresponding entries in arrays.
# This function takes an 'enemy' parameter, removes the corresponding child from the 'Enemies' node,
# and updates the 'enemies' and 'comet_speed' arrays accordingly.
func remove_enemies(enemy):
	var spawned_enemy_comet_speed_index: int = spawned_enemies.find(enemy)
	$Enemies.remove_child(enemy)
	spawned_enemies.erase(enemy)
	comet_speed.remove_at(spawned_enemy_comet_speed_index)


# Timer timeout function: _on_timer_timeout
# Description: Modifies game parameters over time based on the current value of 'minigame2_timer'.
# Adjusts 'minigame2_timerSpeed', 'comet_spawn_count', and calls 'remove_comet_speed' at specific timer values.
func _on_timer_timeout():
	match int(DataScript.minigame2_timer):
		4:
			DataScript.minigame2_timerSpeed = 0.005
			remove_comet_speed(3)
		5:
			DataScript.minigame2_timerSpeed = 0.0025
			comet_spawn_count = 2
		6:
			DataScript.minigame2_timerSpeed = 0.00125
			remove_comet_speed(2)
		7:
			remove_comet_speed(1)
			comet_spawn_count = 3
	DataScript.minigame2_timer += DataScript.minigame2_timerSpeed


# Function: remove_comet_speed
# Description: Removes a comet speed value at the specified index from the 'comet_speed_values' array.
func remove_comet_speed(index):
	if comet_speed_values.size() > index:
		comet_speed_values.remove_at(index)
