# This script extends the Node2D class
# This script handles behavior and interactions for a 2D node in the game.
extends Control 


# Player resources and game data variables.
var firstGame := false
var mooneten := 0
var moonstone := 0
var unixLastTime := 0 # Logout time
var minigame_one_highscore := 0
var minigame_one_score := 0

# Variables for Mini-Game 2.
# Variable to track the current score in Mini-Game 2.
var minigame2_score := 0

# Variable to store the high score in Mini-Game 2.
var minigame2_highscore := 0

# Timer variable for Mini-Game 2.
var minigame2_timer: 
	set(value): minigame2_timer = value
	
# Speed at which the timer in Mini-Game 2 decreases.
var minigame2_timerSpeed

# Constant representing the game speed in Mini-Game 2 as a 2D vector (horizontal speed = 0, vertical speed = 10).
const minigame2_gameSpeed := Vector2(0, 10)

# Variable to track whether the player is currently in the building menu.
# If true, the player is in the building menu; otherwise, false.
var is_in_building_menu:bool = false

# Variables for the maximum amount of Mooneten/Moonstone the player is able to store.
var maxMoonetenStorage := 0
var maxMoonstoneStorage := 0

# Variables for the building ids.
const rocket:int = 0
const shop:int = 1
const moonetenGenerator:int = 2
const moonstoneGenerator:int = 3
const moonetenStorage:int = 4
const moonstoneStorage:int = 5

# Variables for the indices of the field array.
const building_type:int = 0
const name_index:int = 1
const level_index:int = 2
const upgrade_cost_index:int = 3
const image_index:int = 4
const game_path_index:int = 5
const ressource_amount:int = 6
const max_storage_size:int = 7

# Variables for ressource indices of the field array.
const mooneten_amount:int = 0
const moonstone_amount:int = 1

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
var generators_upgrade_costs:Array = [1000,2500,5000,7500]
var storage_upgrade_costs:Array = [3000,9000,15000,25000]
var generators_max_storage_size:Array = [1000,2000,3000,4000,5000]
var storage_max_storage_size:Array = [5000,10000,15000,20000,25000]


# Shopdata as a Dictionary.
var shop_data: Array = [
	{'building_id':moonetenGenerator, 'name': "Moonetengenerator", 'price': 200, 'is_bought': false},
	{'building_id':moonstoneGenerator, 'name': "Moonstonegenerator", 'price': 200, 'is_bought': false},
	{'building_id':moonetenStorage, 'name': "Moonetenstorage", 'price': 1000, 'is_bought': false},
	{'building_id':moonstoneStorage, 'name': "Moonstonestorage", 'price': 1000, 'is_bought': false}
]

# Field array holds all the data of the buildings.
var fieldArray := [[rocket,"Rocket",1,[100000,200000,400000],"","res://Minigame1/minigame_1.tscn", [0, 0], [1000,2000,5000,10000]], [-1], [-1], [-1], [-1], [-1], [-1], [-1], [-1], [-1], [-1], [-1], [-1], [-2]]

# Declare inventory array.
var inventory:Array = []

# Data storage location.
var ressourceBarDataString := "user://playerData.dat"
var fieldDataString := "user://fieldData.dat"

# Declare last player position variable.
var last_player_position: Vector2 = Vector2(168,131)

#Declares the timer
var timer:Timer

# Function: _ready
# Description: Called when the node is ready. Initializes and starts the timer, loads field and player data, and sets maximum resources.
func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 60
	timer.timeout.connect(_on_timeout_timer)
	timer.start()
	loadFieldData()
	setMaxRessources()
	loadPlayerData()
	updateStorageBuildingCapacity()

# Function: _on_timeout_timer
# Description: Called when the timeout timer expires. Adds new mooneten to the player's resources and updates buildings.
func _on_timeout_timer():
	var newMooneten := 10
	var ressourceAmount := 0
	for n in range(0,14):
		if fieldArray[n][building_type] == moonetenGenerator:
			newMooneten = fieldArray[n][level_index] * newMooneten
			if fieldArray[n][ressource_amount][mooneten_amount] <= fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1] - newMooneten:
				ressourceAmount = fieldArray[n][ressource_amount][mooneten_amount] + newMooneten
			else:
				ressourceAmount = fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1]
			fieldArray[n][ressource_amount][mooneten_amount] = ressourceAmount
		elif fieldArray[n][building_type] == moonstoneGenerator:
			newMooneten = fieldArray[n][level_index] * newMooneten
			if fieldArray[n][ressource_amount][moonstone_amount] <= fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1] - newMooneten:
				ressourceAmount = fieldArray[n][ressource_amount][moonstone_amount] + newMooneten
			else:
				ressourceAmount = fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1]
			fieldArray[n][ressource_amount][moonstone_amount] = ressourceAmount
		newMooneten = 10
	timer.start()

# Function: set_building
# Description: Sets the data for a building at a specific field index and saves field data.
func set_building(field_index:int,building:Array):
	fieldArray[field_index] = building
	saveFieldData()
	
# Function: remove_building
# Description: Rmoves the data for a building at a specific field index and saves field data.
func remove_building(field_index:int):
	fieldArray[field_index] = [-1]
	saveFieldData()

# Function: set_inventory
# Description: Sets the inventory data for a building at a specific building index.
func set_inventory(building_index:int,building_name:String, building_level:int,upgrade_costs:Array,image:String,game_path:String, building_ressource_amount:Array, storage_size:Array):
	var building := []
	building.append(building_index)
	building.append(building_name)
	building.append(building_level)#building level
	building.append(upgrade_costs)
	building.append(image)
	building.append(game_path)
	building.append(building_ressource_amount)
	building.append(storage_size)
	inventory.append(building)

# Function: edit_building
# Description: Edits a specific attribute of a building in the fieldArray and saves field data.
func edit_building(building_id:int,attribute_id:int, value):
	fieldArray[building_id][attribute_id] = value
	saveFieldData()

# Function: update_upgrade_costs
# Description: Updates the current upgrade costs with new costs.
func update_upgrade_costs(current_costs:Array,new_costs:Array):
	for cost in new_costs:
		current_costs.append(cost)

# Function: update_storage_size
# Description: Updates the current storage size with new size.
func update_storage_size(current_size:Array,new_size:Array):
	for storage_size in new_size:
		current_size.append(storage_size)

# Function: on_rocket_level_upgrade
# Description: Called when the rocket level is upgraded. Updates shop data based on the rocket level.
func on_rocket_level_upgrade():
	match fieldArray[rocket][2]:
		2:
			update_shop_data(MOONETEN_GENERATOR_CARD, UPGRADE_PRICE_1)
			update_shop_data(MOONSTONE_GENERATOR_CARD, UPGRADE_PRICE_1)
			update_upgrade_costs(generators_upgrade_costs,[10000,30000,60000,90000])
			update_upgrade_costs(storage_upgrade_costs,[80000,120000,150000,180000])
			update_storage_size(generators_max_storage_size,[6000,7000,8000,9000])
			update_storage_size(storage_max_storage_size,[30000,35000,40000,45000])
		3:
			update_shop_data(MOONETEN_GENERATOR_CARD, UPGRADE_PRICE_2)
			update_shop_data(MOONSTONE_GENERATOR_CARD, UPGRADE_PRICE_2)
			update_shop_data(MOONETEN_STORAGE_CARD, UPGRADE_PRICE_3)
			update_shop_data(MOONSTONE_STORAGE_CARD, UPGRADE_PRICE_3)
			update_upgrade_costs(generators_upgrade_costs,[120000,150000,180000,210000])
			update_upgrade_costs(storage_upgrade_costs,[230000,280000,330000,380000])
			update_storage_size(generators_max_storage_size,[10000,12000,14000,18000])
			update_storage_size(storage_max_storage_size,[50000,60000,70000,80000])
		4:
			update_shop_data(MOONETEN_GENERATOR_CARD, UPGRADE_PRICE_4)
			update_upgrade_costs(generators_upgrade_costs,[240000,280000,320000,1000000])
			update_upgrade_costs(storage_upgrade_costs,[430000,500000,600000,700000])
			update_storage_size(generators_max_storage_size,[20000,30000,40000,50000])
			update_storage_size(storage_max_storage_size,[100000,120000,140000,160000])

# Function: update_shop_data
# Description: Updates the price and is_bought status for a specific shop item and saves player data.
func update_shop_data(shop_id, new_price):
	shop_data[shop_id]["price"] = new_price
	shop_data[shop_id]["is_bought"] = false
	savePlayerData()

# Function: setMooneten
# Description: Setter function for the mooneten variable.
# Parameters:
#   - value: New value to set for mooneten.
func setMooneten(value):
	mooneten = value
	savePlayerData()
	updateStorageBuildingCapacity()

# Function: getMooneten
# Description: Getter function for the mooneten variable.
# Returns: The value of mooneten.
func getMooneten():
	return mooneten

# Function: addMooneten
# Description: Adds the specified value to the mooneten variable and saves player data.
# Parameters:
#   - value: The amount to add to the mooneten variable.
func addMooneten(value):
	mooneten = mooneten + value
	savePlayerData()
	updateStorageBuildingCapacity()

# Function: removeMooneten
# Description: Subtracts the specified value from the mooneten variable and saves player data.
# Parameters:
#   - value: The amount to subtract from the mooneten variable.
func removeMooneten(value):
	mooneten = mooneten - value
	savePlayerData()
	updateStorageBuildingCapacity()

# Function: setUnixLastTime
# Description: Setter function for the unixLastTime variable.
# Parameters:
#   - value: New value to set for unixLastTime.
func setUnixLastTime(value):
	unixLastTime = value
	savePlayerData()

# Function: getUnixLastTime
# Description: Getter function for the unixLastTime variable.
# Returns: The value of unixLastTime.
func getUnixLastTime():
	return unixLastTime

# Function: setMoonstone
# Description: Setter function for the moonstone variable.
# Parameters:
#   - value: New value to set for moonstone.
func setMoonstone(value):
	moonstone = value
	savePlayerData()
	updateStorageBuildingCapacity()

# Function: getMoonstone
# Description: Getter function for the moonstone variable.
# Returns: The value of moonstone.
func getMoonstone():
	return moonstone

# Function: addMoonstone
# Description: Adds the specified value to the moonstone variable and saves player data.
# Parameters:
#   - value: The amount to add to the moonstone variable.
func addMoonstone(value):
	moonstone = moonstone + value
	savePlayerData()
	updateStorageBuildingCapacity()

# Function: removeMoonstone
# Description: Subtracts the specified value from the moonstone variable and saves player data.
# Parameters:
#   - value: The amount to subtract from the moonstone variable.
func removeMoonstone(value):
	moonstone = moonstone - value
	savePlayerData()
	updateStorageBuildingCapacity()

# Function: setM1Score
# Description: Setter function for the minigame_one_score variable.
# Parameters:
#   - value: New score value to set minigame_one_score.
func setM1Score(value):
	minigame_one_score = value
	if minigame_one_score >= minigame_one_highscore:
		minigame_one_highscore = minigame_one_score
		savePlayerData()

# Function: setMinigame2_highscore
# Description: Setter function for the minigame2_highscore variable.
# Parameters:
#   - value: New highscore value to set minigame2_highscore.
func setMinigame2_highscore(value):
	if value > minigame2_highscore:
		minigame2_highscore = value
		savePlayerData()

# Function: getMinigame2_highscore
# Description: Getter function for the minigame2_highscore variable.
# Returns: The value of minigame2_highscore.
func getMinigame2_highscore():
	return minigame2_highscore

# Function: getM1Score
# Description: Getter function for the minigame_one_score variable.
# Returns: The value of minigame_one_score.
func getM1Score():
	return minigame_one_score	

# Function: setMinigame2_score
# Description: Setter function for the minigame2_score variable.
# Parameters:
#   - value: New score value to set minigame2_score.
func setMinigame2_score(value):
	minigame2_score = value
	savePlayerData()

# Function: getMinigame2_score
# Description: Getter function for the minigame2_score variable.
# Returns: The value of minigame2_score.
func getMinigame2_score():
	return minigame2_score

# Function: getM1HighScore
# Description: Getter function for the minigame_one_highscore variable.
# Returns: The value of minigame_one_highscore.
func getM1HighScore():
	return minigame_one_highscore

# Function: isPlayingFirstTime
# Description: Checks if the game is being played for the first time.
# Returns: True if it's the first time, False otherwise.
func isPlayingFirstTime():
	return firstGame

# Function: setFirstGame
# Description: Setter function for the firstGame variable.
# Parameters:
#   - value: Boolean value to set firstGame.
func setFirstGame(value):
	firstGame = value
	savePlayerData()

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
	savePlayerData()

# Function: updateStorageBuildingCapacity
# Description: Updates the storage capacity of specific buildings in the fieldArray based on their type.
#              It resets the current capacity and then sets the updated capacity for each eligible building.
func updateStorageBuildingCapacity():
	resetStorageBuildingCapacity()
	setStorageBuildingCapacity()
	
# Function: resetStorageBuildingCapacity
# Description: Resets the current resource capacity of storage buildings in the fieldArray.
func resetStorageBuildingCapacity():
	for n in range(0,14):
		if fieldArray[n][building_type] == rocket || fieldArray[n][building_type] == moonetenStorage || fieldArray[n][building_type] == moonstoneStorage:
			fieldArray[n][ressource_amount][mooneten_amount] = 0
			fieldArray[n][ressource_amount][moonstone_amount] = 0

# Function: setStorageBuildingCapacity
# Description: Sets the updated resource capacity for eligible storage buildings in the fieldArray.
func setStorageBuildingCapacity():
	var i : int = 0
	var spaceAvailable : int = 0
	var tempMooneten : int = getMooneten()
	while i < 14 && tempMooneten > 0:
		if fieldArray[i][building_type] == rocket || fieldArray[i][building_type] == moonetenStorage:
			spaceAvailable = fieldArray[i][max_storage_size][fieldArray[i][level_index] - 1] - fieldArray[i][ressource_amount][mooneten_amount]
			if spaceAvailable > 0:
				if tempMooneten <= spaceAvailable:
					fieldArray[i][ressource_amount][mooneten_amount] += tempMooneten
					tempMooneten = 0
				else:
					fieldArray[i][ressource_amount][mooneten_amount] = fieldArray[i][max_storage_size][fieldArray[i][level_index] - 1]
					tempMooneten -= spaceAvailable
		i += 1
	
	spaceAvailable = 0
	i = 0
	var tempMoonstone : int = getMoonstone()
	while i < 14 && tempMoonstone > 0:
		if fieldArray[i][building_type] == rocket || fieldArray[i][building_type] == moonstoneStorage:
			spaceAvailable = fieldArray[i][max_storage_size][fieldArray[i][level_index] - 1] - fieldArray[i][ressource_amount][moonstone_amount]
			if spaceAvailable > 0:
				if tempMoonstone <= spaceAvailable:
					fieldArray[i][ressource_amount][moonstone_amount] += tempMoonstone
					tempMoonstone = 0
				else:
					fieldArray[i][ressource_amount][moonstone_amount] = fieldArray[i][max_storage_size][fieldArray[i][level_index] - 1]
					tempMoonstone -= spaceAvailable
		i += 1

# Function: savePlayerData
# Description: Saves player data to a file.
func savePlayerData():
	var file = FileAccess.open(ressourceBarDataString, FileAccess.WRITE)
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

# Function: loadPlayerData
# Description: Loads player data from a file if it exists; otherwise, initializes default values.
func loadPlayerData():
	if FileAccess.file_exists(ressourceBarDataString):
		var file = FileAccess.open(ressourceBarDataString, FileAccess.READ)
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
		addOfflineMooneten()
	else:
		firstGame = true
		unixLastTime = Time.get_unix_time_from_system()
		savePlayerData()

# Function: saveFieldData
# Description: Saves the field data to a file.
func saveFieldData():
	var file = FileAccess.open(fieldDataString, FileAccess.WRITE)
	for n in range(0,14):
		file.store_var(fieldArray[n])

# Function: loadFieldData
# Description: Loads the field data from a file. If the file doesn't exist, it creates one.
func loadFieldData():
	if FileAccess.file_exists(fieldDataString):
		var file = FileAccess.open(fieldDataString, FileAccess.READ)
		for n in range(0,14):
			fieldArray[n] = file.get_var()
	else:
		saveFieldData()

# Function: addOfflineMooneten
# Description: Adds mooneten resources based on the time the player was offline.
# It calculates the offlineMooneten amount and distributes it among generators.
# Players can earn up to 1000 mooneten while being offline.
func addOfflineMooneten():
	var diff = Time.get_unix_time_from_system() - getUnixLastTime()
	diff = diff / 60
	diff = round(diff)
	var offlineMooneten = diff * 5
	if offlineMooneten > 1000:
		offlineMooneten = 1000
	if (getMooneten() + offlineMooneten) <= maxMoonetenStorage:	
		addMooneten(offlineMooneten)
	else:
		setMooneten(maxMoonetenStorage)
	
	var ressourceAmount := 0
	for n in range(0,14):
		if fieldArray[n][building_type] == moonetenGenerator:
			offlineMooneten = fieldArray[n][level_index] * offlineMooneten
			if offlineMooneten <= 1000:
				if fieldArray[n][ressource_amount][mooneten_amount] <= fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1] - offlineMooneten:
					ressourceAmount = fieldArray[n][ressource_amount][mooneten_amount] + offlineMooneten
				else:
					ressourceAmount = fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1]
			else:
				offlineMooneten = 1000
				if fieldArray[n][ressource_amount][mooneten_amount] <= fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1] - offlineMooneten:
					ressourceAmount = fieldArray[n][ressource_amount][mooneten_amount] + offlineMooneten
				else:
					ressourceAmount = fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1]
			#print("Building: " + str(n) + " - Added: " + str(offlineMooneten) + " - RessourceAmount: " + str(ressourceAmount))
			fieldArray[n][ressource_amount][mooneten_amount] = ressourceAmount
		elif fieldArray[n][building_type] == moonstoneGenerator:
			offlineMooneten = fieldArray[n][level_index] * offlineMooneten
			if offlineMooneten <= 1000:
				if fieldArray[n][ressource_amount][moonstone_amount] <= fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1] - offlineMooneten:
					ressourceAmount = fieldArray[n][ressource_amount][moonstone_amount] + offlineMooneten
				else:
					ressourceAmount = fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1]
			else:
				offlineMooneten = 1000
				if fieldArray[n][ressource_amount][moonstone_amount] <= fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1] - offlineMooneten:
					ressourceAmount = fieldArray[n][ressource_amount][moonstone_amount] + offlineMooneten
				else:
					ressourceAmount = fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1]
			#print("Building: " + str(n) + " - Added: " + str(offlineMooneten) + " - RessourceAmount: " + str(ressourceAmount))
			fieldArray[n][ressource_amount][moonstone_amount] = ressourceAmount
		offlineMooneten = diff * 5

# Function: setMaxRessources
# Description: Sets the maximum storage capacity for mooneten and moonstone based on buildings.
func setMaxRessources():
	var tempMooneten := 0
	var tempMoonstone := 0
	for n in range(1,14):
		if fieldArray[n][building_type] == moonetenStorage:
			tempMooneten += fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1]
		if fieldArray[n][building_type] == moonstoneStorage:
			tempMoonstone += fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1]
	tempMooneten += fieldArray[rocket][max_storage_size][fieldArray[rocket][level_index] - 1]
	tempMoonstone += fieldArray[rocket][max_storage_size][fieldArray[rocket][level_index] - 1]
	maxMoonetenStorage = tempMooneten
	maxMoonstoneStorage = tempMoonstone

# Function: resetStats
# Description: Resets various game-related statistics to their initial values.
func resetStats():
	firstGame = true
	mooneten = 1300
	moonstone = 0
	unixLastTime = Time.get_unix_time_from_system()
	minigame2_highscore = 0
	minigame_one_highscore = 0
	fieldArray = [[rocket,"Rocket",1,[100000,200000,400000],"","res://Minigame1/minigame_1.tscn", [0, 0], [1000,2000,5000,10000]], [-1], [-1], [-1], [-1], [-1], [-1], [-1], [-1], [-1], [-1], [-1], [-1], [-2]]
	last_player_position = Vector2(168,131)
	shop_data = [
	{'building_id':moonetenGenerator, 'name': "Moonetengenerator", 'price': 200, 'is_bought': false},
	{'building_id':moonstoneGenerator, 'name': "Moonstonegenerator", 'price': 200, 'is_bought': false},
	{'building_id':moonetenStorage, 'name': "Moonetenstorage", 'price': 1000, 'is_bought': false},
	{'building_id':moonstoneStorage, 'name': "Moonstonestorage", 'price': 1000, 'is_bought': false}]
	inventory = []
	generators_upgrade_costs = [1000,2500,5000,7500]
	storage_upgrade_costs = [3000,9000,15000,25000]
	generators_max_storage_size = [1000,2000,3000,4000,5000]
	storage_max_storage_size = [5000,10000,15000,20000,25000]
	setMaxRessources()
	savePlayerData()
	saveFieldData()
