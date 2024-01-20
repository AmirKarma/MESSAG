# This script extends the Node2D class
# This script handles behavior and interactions for a 2D node in the game.
extends Control

# Player resources and game data variables.
var firstGame: bool = false
var mooneten: int = 0
var moonstone: int = 0
var unixLastTime: int = 0  # Logout time
var minigame_one_highscore: int = 0
var minigame_one_score: int = 0

# Variables for Mini-Game 2.
# Variable to track the current score in Mini-Game 2.
var minigame2_score: int = 0

# Variable to store the high score in Mini-Game 2.
var minigame2_highscore: int = 0

# Timer variable for Mini-Game 2.
var minigame2_timer: float:
	set(value):
		minigame2_timer = value

# Speed at which the timer in Mini-Game 2 decreases.
var minigame2_timerSpeed: float

# Constant representing the game speed in Mini-Game 2 as a 2D vector
# (horizontal speed = 0, vertical speed = 10).
const MINIGAME2_GAMESPEED: Vector2 = Vector2(0, 10)

# Variable to track whether the player is currently in the building menu.
# If true, the player is in the building menu; otherwise, false.
var is_in_building_menu: bool = false

# Variables for the maximum amount of Mooneten/Moonstone the player is able to store.
var maxMoonetenStorage: int = 0
var maxMoonstoneStorage: int = 0

# Variables for the building ids.
const ROCKET: int = 0
const SHOP: int = 1
const MOONETEN_GENERATOR: int = 2
const moonstoneGenerator: int = 3
const moonetenStorage: int = 4
const moonstoneStorage: int = 5

# Variables for the indices of the field array.
const building_type: int = 0
const name_index: int = 1
const level_index: int = 2
const upgrade_cost_index: int = 3
const image_index: int = 4
const game_path_index: int = 5
const RESSOURCE_AMOUNT: int = 6
const max_storage_size: int = 7

# Variables for ressource indices of the field array.
const mooneten_amount: int = 0
const moonstone_amount: int = 1

# Constans for shopelements.
const MOONETEN_GENERATOR_CARD = 0
const MOONSTONE_GENERATOR_CARD = 1
const MOONETEN_STORAGE_CARD = 2
const MOONSTONE_STORAGE_CARD = 3

# Constans for priceupdates.
const UPGRADE_PRICE_1 = 2000
const UPGRADE_PRICE_2 = 10000
const UPGRADE_PRICE_3 = 50000
const UPGRADE_PRICE_4 = 75000

# Variables for the upgrade costs of each building type.
var generators_upgrade_costs: Array = [1000, 2500, 5000, 7500]
var storage_upgrade_costs: Array = [3000, 9000, 15000, 25000]
var generators_max_storage_size: Array = [1000, 2000, 3000, 4000, 5000]
var storage_max_storage_size: Array = [5000, 10000, 15000, 20000, 25000]

# Shopdata as a Dictionary.
var shop_data: Array = [
	{
		"building_id": MOONETEN_GENERATOR,
		"name": "Moonetengenerator",
		"price": 200,
		"is_bought": false
	},
	{
		"building_id": moonstoneGenerator,
		"name": "Moonstonegenerator",
		"price": 200,
		"is_bought": false
	},
	{"building_id": moonetenStorage, "name": "Moonetenstorage", "price": 1000, "is_bought": false},
	{"building_id": moonstoneStorage, "name": "Moonstonestorage", "price": 1000, "is_bought": false}
]

# Field array holds all the data of the buildings.
var fieldArray: Array = [
	[
		ROCKET,
		"Rocket",
		1,
		[100000, 200000, 400000],
		"",
		"res://Minigame1/Scenes/minigame_1.tscn",
		[0, 0],
		[1000, 2000, 5000, 10000]
	],
	[-1],
	[-1],
	[-1],
	[-1],
	[-1],
	[-1],
	[-1],
	[-1],
	[-1],
	[-1],
	[-1],
	[-1],
	[-2]
]

# Declare inventory array.
var inventory: Array = []

# Data storage location.
var ressourceBarDataString: String = "user://playerData.dat"
var fieldDataString: String = "user://fieldData.dat"

# Declare last player position variable.
var last_player_position: Vector2 = Vector2(168, 131)

#Declares the timer.
var timer: Timer


# Function: _ready
# Description: Called when the node is ready.
# Initializes and starts the timer, loads field and player data, and sets maximum resources.
func _ready():
	print(minigame2_timer)
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 60
	timer.timeout.connect(_on_timeout_timer)
	timer.start()
	load_field_data()
	set_max_ressources()
	load_player_data()
	update_storage_building_capacity()


# Function: _on_timeout_timer
# Description: Called when the timeout timer expires.
# Adds new mooneten to the player's resources and updates buildings.
func _on_timeout_timer():
	var new_mooneten: int = 10
	var ressourceamount: int = 0
	for n in range(0, 14):
		if fieldArray[n][building_type] == MOONETEN_GENERATOR:
			new_mooneten = fieldArray[n][level_index] * new_mooneten
			if (
				fieldArray[n][RESSOURCE_AMOUNT][mooneten_amount]
				<= fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1] - new_mooneten
			):
				ressourceamount = fieldArray[n][RESSOURCE_AMOUNT][mooneten_amount] + new_mooneten
			else:
				ressourceamount = fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1]
			fieldArray[n][RESSOURCE_AMOUNT][mooneten_amount] = ressourceamount
		elif fieldArray[n][building_type] == moonstoneGenerator:
			new_mooneten = fieldArray[n][level_index] * new_mooneten
			if (
				fieldArray[n][RESSOURCE_AMOUNT][moonstone_amount]
				<= fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1] - new_mooneten
			):
				ressourceamount = fieldArray[n][RESSOURCE_AMOUNT][moonstone_amount] + new_mooneten
			else:
				ressourceamount = fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1]
			fieldArray[n][RESSOURCE_AMOUNT][moonstone_amount] = ressourceamount
		new_mooneten = 10
	timer.start()


# Function: set_building
# Description: Sets the data for a building at a specific field index and saves field data.
func set_building(field_index: int, building: Array):
	fieldArray[field_index] = building
	save_field_data()


# Function: remove_building
# Description: Rmoves the data for a building at a specific field index and saves field data.
func remove_building(field_index: int):
	fieldArray[field_index] = [-1]
	save_field_data()


# Function: set_inventory
# Description: Sets the inventory data for a building at a specific building index.
func set_inventory(
	building_index: int,
	building_name: String,
	building_level: int,
	upgrade_costs: Array,
	image: String,
	game_path: String,
	building_ressource_amount: Array,
	storage_size: Array
):
	var building: Array = []
	building.append(building_index)
	building.append(building_name)
	building.append(building_level)  #building level
	building.append(upgrade_costs)
	building.append(image)
	building.append(game_path)
	building.append(building_ressource_amount)
	building.append(storage_size)
	inventory.append(building)


# Function: edit_building
# Description: Edits a specific attribute of a building in the fieldArray and saves field data.
func edit_building(building_id: int, attribute_id: int, value):
	fieldArray[building_id][attribute_id] = value
	save_field_data()


# Function: update_upgrade_costs
# Description: Updates the current upgrade costs with new costs.
func update_upgrade_costs(current_costs: Array, new_costs: Array):
	for cost in new_costs:
		current_costs.append(cost)


# Function: update_storage_size
# Description: Updates the current storage size with new size.
func update_storage_size(current_size: Array, new_size: Array):
	for storage_size in new_size:
		current_size.append(storage_size)


# Function: on_rocket_level_upgrade
# Description: Called when the rocket level is upgraded.
# Updates shop data based on the rocket level.
func on_rocket_level_upgrade():
	match fieldArray[ROCKET][2]:
		2:
			update_shop_data(MOONETEN_GENERATOR_CARD, UPGRADE_PRICE_1)
			update_shop_data(MOONSTONE_GENERATOR_CARD, UPGRADE_PRICE_1)
			update_upgrade_costs(generators_upgrade_costs, [10000, 30000, 60000, 90000])
			update_upgrade_costs(storage_upgrade_costs, [80000, 120000, 150000, 180000])
			update_storage_size(generators_max_storage_size, [6000, 7000, 8000, 9000])
			update_storage_size(storage_max_storage_size, [30000, 35000, 40000, 45000])
		3:
			update_shop_data(MOONETEN_GENERATOR_CARD, UPGRADE_PRICE_2)
			update_shop_data(MOONSTONE_GENERATOR_CARD, UPGRADE_PRICE_2)
			update_shop_data(MOONETEN_STORAGE_CARD, UPGRADE_PRICE_3)
			update_shop_data(MOONSTONE_STORAGE_CARD, UPGRADE_PRICE_3)
			update_upgrade_costs(generators_upgrade_costs, [120000, 150000, 180000, 210000])
			update_upgrade_costs(storage_upgrade_costs, [230000, 280000, 330000, 380000])
			update_storage_size(generators_max_storage_size, [10000, 12000, 14000, 18000])
			update_storage_size(storage_max_storage_size, [50000, 60000, 70000, 80000])
		4:
			update_shop_data(MOONETEN_GENERATOR_CARD, UPGRADE_PRICE_4)
			update_upgrade_costs(generators_upgrade_costs, [240000, 280000, 320000, 1000000])
			update_upgrade_costs(storage_upgrade_costs, [430000, 500000, 600000, 700000])
			update_storage_size(generators_max_storage_size, [20000, 30000, 40000, 50000])
			update_storage_size(storage_max_storage_size, [100000, 120000, 140000, 160000])


# Function: update_shop_data
# Description: Updates the price and is_bought status
# for a specific shop item and saves player data.
func update_shop_data(shop_id, new_price):
	shop_data[shop_id]["price"] = new_price
	shop_data[shop_id]["is_bought"] = false
	save_player_data()


# Function: set_mooneten
# Description: Setter function for the mooneten variable.
# Parameters:
#   - value: New value to set for mooneten.
func set_mooneten(value):
	mooneten = value
	save_player_data()
	update_storage_building_capacity()


# Function: get_mooneten
# Description: Getter function for the mooneten variable.
# Returns: The value of mooneten.
func get_mooneten():
	return mooneten


# Function: add_mooneten
# Description: Adds the specified value to the mooneten variable and saves player data.
# Parameters:
#   - value: The amount to add to the mooneten variable.
func add_mooneten(value):
	mooneten = mooneten + value
	save_player_data()
	update_storage_building_capacity()


# Function: remove_mooneten
# Description: Subtracts the specified value from the mooneten variable and saves player data.
# Parameters:
#   - value: The amount to subtract from the mooneten variable.
func remove_mooneten(value):
	mooneten = mooneten - value
	save_player_data()
	update_storage_building_capacity()


# Function: set_unix_last_time
# Description: Setter function for the unixLastTime variable.
# Parameters:
#   - value: New value to set for unixLastTime.
func set_unix_last_time(value):
	unixLastTime = value
	save_player_data()


# Function: get_unix_last_time
# Description: Getter function for the unixLastTime variable.
# Returns: The value of unixLastTime.
func get_unix_last_time():
	return unixLastTime


# Function: set_moonstone
# Description: Setter function for the moonstone variable.
# Parameters:
#   - value: New value to set for moonstone.
func set_moonstone(value):
	moonstone = value
	save_player_data()
	update_storage_building_capacity()


# Function: get_moonstone
# Description: Getter function for the moonstone variable.
# Returns: The value of moonstone.
func get_moonstone():
	return moonstone


# Function: add_moonstone
# Description: Adds the specified value to the moonstone variable and saves player data.
# Parameters:
#   - value: The amount to add to the moonstone variable.
func add_moonstone(value):
	moonstone = moonstone + value
	save_player_data()
	update_storage_building_capacity()


# Function: remove_moonstone
# Description: Subtracts the specified value from the moonstone variable and saves player data.
# Parameters:
#   - value: The amount to subtract from the moonstone variable.
func remove_moonstone(value):
	moonstone = moonstone - value
	save_player_data()
	update_storage_building_capacity()


# Function: set_minigame1_score
# Description: Setter function for the minigame_one_score variable.
# Parameters:
#   - value: New score value to set minigame_one_score.
func set_minigame1_score(value):
	minigame_one_score = value
	if minigame_one_score >= minigame_one_highscore:
		minigame_one_highscore = minigame_one_score
		save_player_data()


# Function: set_minigame2_highscore
# Description: Setter function for the minigame2_highscore variable.
# Parameters:
#   - value: New highscore value to set minigame2_highscore.
func set_minigame2_highscore(value):
	if value > minigame2_highscore:
		minigame2_highscore = value
		save_player_data()


# Function: get_minigame2_highscore
# Description: Getter function for the minigame2_highscore variable.
# Returns: The value of minigame2_highscore.
func get_minigame2_highscore():
	return minigame2_highscore


# Function: get_minigame1_score
# Description: Getter function for the minigame_one_score variable.
# Returns: The value of minigame_one_score.
func get_minigame1_score():
	return minigame_one_score


# Function: set_minigame2_score
# Description: Setter function for the minigame2_score variable.
# Parameters:
#   - value: New score value to set minigame2_score.
func set_minigame2_score(value):
	minigame2_score = value
	save_player_data()


# Function: get_minigame2_score
# Description: Getter function for the minigame2_score variable.
# Returns: The value of minigame2_score.
func get_minigame2_score():
	return minigame2_score


# Function: get_minigame1_highscore
# Description: Getter function for the minigame_one_highscore variable.
# Returns: The value of minigame_one_highscore.
func get_minigame1_highscore():
	return minigame_one_highscore


# Function: is_playing_first_time
# Description: Checks if the game is being played for the first time.
# Returns: True if it's the first time, False otherwise.
func is_playing_first_time():
	return firstGame


# Function: set_first_game
# Description: Setter function for the firstGame variable.
# Parameters:
#   - value: Boolean value to set firstGame.
func set_first_game(value):
	firstGame = value
	save_player_data()


# Function: get_last_player_position
# Description: Getter function for the last_player_position variable.
# Returns: The value of last_player_position.
func get_last_player_position():
	return last_player_position


# Function: set_last_player_position
# Description: Setter function for the last_player_position variable.
# Parameters:
#   - value: New position value to set last_player_position.
func set_last_player_position(value):
	last_player_position = value
	save_player_data()


# Function: update_storage_building_capacity
# Description: Updates the storage capacity of specific buildings in the fieldArray based on their type.
# It resets the current capacity and then sets the updated capacity for each eligible building.
func update_storage_building_capacity():
	reset_storage_building_capacity()
	set_storage_building_capacity()


# Function: reset_storage_building_capacity
# Description: Resets the current resource capacity of storage buildings in the fieldArray.
func reset_storage_building_capacity():
	for n in range(0, 14):
		if (
			fieldArray[n][building_type] == ROCKET
			|| fieldArray[n][building_type] == moonetenStorage
			|| fieldArray[n][building_type] == moonstoneStorage
		):
			fieldArray[n][RESSOURCE_AMOUNT][mooneten_amount] = 0
			fieldArray[n][RESSOURCE_AMOUNT][moonstone_amount] = 0


# Function: set_storage_building_capacity
# Description: Sets the updated resource capacity for eligible storage buildings in the fieldArray.
func set_storage_building_capacity():
	var i: int = 0
	var space_available: int = 0
	var temp_mooneten: int = get_mooneten()
	while i < 14 && temp_mooneten > 0:
		if (
			fieldArray[i][building_type] == ROCKET
			|| fieldArray[i][building_type] == moonetenStorage
		):
			space_available = (
				fieldArray[i][max_storage_size][fieldArray[i][level_index] - 1]
				- fieldArray[i][RESSOURCE_AMOUNT][mooneten_amount]
			)
			if space_available > 0:
				if temp_mooneten <= space_available:
					fieldArray[i][RESSOURCE_AMOUNT][mooneten_amount] += temp_mooneten
					temp_mooneten = 0
				else:
					fieldArray[i][RESSOURCE_AMOUNT][mooneten_amount] = fieldArray[i][max_storage_size][
						fieldArray[i][level_index] - 1
					]
					temp_mooneten -= space_available
		i += 1

	space_available = 0
	i = 0
	var temp_moonstone: int = get_moonstone()
	while i < 14 && temp_moonstone > 0:
		if (
			fieldArray[i][building_type] == ROCKET
			|| fieldArray[i][building_type] == moonstoneStorage
		):
			space_available = (
				fieldArray[i][max_storage_size][fieldArray[i][level_index] - 1]
				- fieldArray[i][RESSOURCE_AMOUNT][moonstone_amount]
			)
			if space_available > 0:
				if temp_moonstone <= space_available:
					fieldArray[i][RESSOURCE_AMOUNT][moonstone_amount] += temp_moonstone
					temp_moonstone = 0
				else:
					fieldArray[i][RESSOURCE_AMOUNT][moonstone_amount] = fieldArray[i][max_storage_size][
						fieldArray[i][level_index] - 1
					]
					temp_moonstone -= space_available
		i += 1


# Function: save_player_data
# Description: Saves player data to a file.
func save_player_data():
	var file: FileAccess = FileAccess.open(ressourceBarDataString, FileAccess.WRITE)
	file.store_var(firstGame)
	file.store_var(mooneten)
	file.store_var(moonstone)
	file.store_var(unixLastTime)
	file.store_var(minigame2_highscore)
	file.store_var(minigame_one_highscore)
	file.store_var(last_player_position)
	file.store_var(shop_data)
	file.store_var(inventory)
	file.store_var(generators_upgrade_costs)
	file.store_var(storage_upgrade_costs)
	file.store_var(generators_max_storage_size)
	file.store_var(storage_max_storage_size)


# Function: load_player_data
# Description: Loads player data from a file if it exists; otherwise, initializes default values.
func load_player_data():
	if FileAccess.file_exists(ressourceBarDataString):
		var file: FileAccess = FileAccess.open(ressourceBarDataString, FileAccess.READ)
		firstGame = file.get_var()
		mooneten = file.get_var()
		moonstone = file.get_var()
		unixLastTime = file.get_var()
		minigame2_highscore = file.get_var()
		minigame_one_highscore = file.get_var()
		last_player_position = file.get_var()
		shop_data = file.get_var()
		inventory = file.get_var()
		generators_upgrade_costs = file.get_var()
		storage_upgrade_costs = file.get_var()
		generators_max_storage_size = file.get_var()
		storage_max_storage_size = file.get_var()
		add_offline_mooneten()
	else:
		firstGame = true
		unixLastTime = Time.get_unix_time_from_system()
		save_player_data()


# Function: save_field_data
# Description: Saves the field data to a file.
func save_field_data():
	var file: FileAccess = FileAccess.open(fieldDataString, FileAccess.WRITE)
	for n in range(0, 14):
		file.store_var(fieldArray[n])


# Function: load_field_data
# Description: Loads the field data from a file. If the file doesn't exist, it creates one.
# BEGIN: ed8c6549bwf9
func load_field_data():
	if FileAccess.file_exists(fieldDataString):
		var file: FileAccess = FileAccess.open(fieldDataString, FileAccess.READ)
		for n in range(0, 14):
			fieldArray[n] = file.get_var()
	else:
		save_field_data()


# END: ed8c6549bwf9


# Function: add_offline_mooneten
# Description: Adds mooneten resources based on the time the player was offline.
# It calculates the offline_mooneten amount and distributes it among generators.
func add_offline_mooneten():
	var time_difference: float = float(Time.get_unix_time_from_system() - get_unix_last_time())
	var diff: float = time_difference / 60.0  # Keep diff as float for precision
	var rounded_diff: int = round(diff)  # Round the result when necessary
	var offline_mooneten: int = rounded_diff * 5
	if offline_mooneten > 1000:
		offline_mooneten = 1000
	var ressourceamount: int = 0
	for n in range(0, 14):
		if fieldArray[n][building_type] == MOONETEN_GENERATOR:
			offline_mooneten = fieldArray[n][level_index] * offline_mooneten
			if offline_mooneten <= 1000:
				if (
					fieldArray[n][RESSOURCE_AMOUNT][mooneten_amount]
					<= (
						fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1]
						- offline_mooneten
					)
				):
					ressourceamount = (
						fieldArray[n][RESSOURCE_AMOUNT][mooneten_amount] + offline_mooneten
					)
				else:
					ressourceamount = fieldArray[n][max_storage_size][
						fieldArray[n][level_index] - 1
					]
			else:
				offline_mooneten = 1000
				if (
					fieldArray[n][RESSOURCE_AMOUNT][mooneten_amount]
					<= (
						fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1]
						- offline_mooneten
					)
				):
					ressourceamount = (
						fieldArray[n][RESSOURCE_AMOUNT][mooneten_amount] + offline_mooneten
					)
				else:
					ressourceamount = fieldArray[n][max_storage_size][
						fieldArray[n][level_index] - 1
					]

			fieldArray[n][RESSOURCE_AMOUNT][mooneten_amount] = ressourceamount
		elif fieldArray[n][building_type] == moonstoneGenerator:
			offline_mooneten = fieldArray[n][level_index] * offline_mooneten
			if offline_mooneten <= 1000:
				if (
					fieldArray[n][RESSOURCE_AMOUNT][moonstone_amount]
					<= (
						fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1]
						- offline_mooneten
					)
				):
					ressourceamount = (
						fieldArray[n][RESSOURCE_AMOUNT][moonstone_amount] + offline_mooneten
					)
				else:
					ressourceamount = fieldArray[n][max_storage_size][
						fieldArray[n][level_index] - 1
					]
			else:
				offline_mooneten = 1000
				if (
					fieldArray[n][RESSOURCE_AMOUNT][moonstone_amount]
					<= (
						fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1]
						- offline_mooneten
					)
				):
					ressourceamount = (
						fieldArray[n][RESSOURCE_AMOUNT][moonstone_amount] + offline_mooneten
					)
				else:
					ressourceamount = fieldArray[n][max_storage_size][
						fieldArray[n][level_index] - 1
					]
			fieldArray[n][RESSOURCE_AMOUNT][moonstone_amount] = ressourceamount
		offline_mooneten = diff * 5


# Function: set_max_ressources
# Description: Sets the maximum storage capacity for mooneten and moonstone based on buildings.
func set_max_ressources():
	var temp_mooneten: int = 0
	var temp_moonstone: int = 0

	for n in range(1, 14):
		if fieldArray[n][building_type] == moonetenStorage:
			temp_mooneten += fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1]
		if fieldArray[n][building_type] == moonstoneStorage:
			temp_moonstone += fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1]
	temp_mooneten += fieldArray[ROCKET][max_storage_size][fieldArray[ROCKET][level_index] - 1]
	temp_moonstone += fieldArray[ROCKET][max_storage_size][fieldArray[ROCKET][level_index] - 1]
	maxMoonetenStorage = temp_mooneten
	maxMoonstoneStorage = temp_moonstone


# Function: reset_stats
# Description: Resets various game-related statistics to their initial values.
func reset_stats():
	firstGame = true
	mooneten = 0
	moonstone = 0
	unixLastTime = Time.get_unix_time_from_system()
	minigame2_highscore = 0
	minigame_one_highscore = 0
	fieldArray = [
		[
			ROCKET,
			"Rocket",
			1,
			[100000, 200000, 400000],
			"",
			"res://Minigame1/Scenes/minigame_1.tscn",
			[0, 0],
			[1000, 2000, 5000, 10000]
		],
		[-1],
		[-1],
		[-1],
		[-1],
		[-1],
		[-1],
		[-1],
		[-1],
		[-1],
		[-1],
		[-1],
		[-1],
		[-2]
	]
	last_player_position = Vector2(168, 131)
	shop_data = [
		{
			"building_id": MOONETEN_GENERATOR,
			"name": "Moonetengenerator",
			"price": 200,
			"is_bought": false
		},
		{
			"building_id": moonstoneGenerator,
			"name": "Moonstonegenerator",
			"price": 200,
			"is_bought": false
		},
		{
			"building_id": moonetenStorage,
			"name": "Moonetenstorage",
			"price": 1000,
			"is_bought": false
		},
		{
			"building_id": moonstoneStorage,
			"name": "Moonstonestorage",
			"price": 1000,
			"is_bought": false
		}
	]
	inventory = []
	generators_upgrade_costs = [1000, 2500, 5000, 7500]
	storage_upgrade_costs = [3000, 9000, 15000, 25000]
	generators_max_storage_size = [1000, 2000, 3000, 4000, 5000]
	storage_max_storage_size = [5000, 10000, 15000, 20000, 25000]
	set_max_ressources()
	save_player_data()
	save_field_data()
