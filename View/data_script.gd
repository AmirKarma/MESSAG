# This script extends the Node2D class
# This script handles behavior and interactions for a 2D node in the game.
extends Control 


# Player resources and game data variables
var firstGame := false
var mooneten := 0 
var moonstone := 0
var unixLastTime := 0 #logout time
var minigame_one_highscore := 0
var minigame_one_score := 0

# Variables for Mini-Game 2
# Variable to track the current score in Mini-Game 2
var minigame2_score := 0
# Variable to store the high score in Mini-Game 2
var minigame2_highscore := 0
# Timer variable for Mini-Game 2
var minigame2_timer: 
	set(value): minigame2_timer = value
# Speed at which the timer in Mini-Game 2 decreases
var minigame2_timerSpeed
# Constant representing the game speed in Mini-Game 2 as a 2D vector (horizontal speed = 0, vertical speed = 10)
const minigame2_gameSpeed := Vector2(0, 10)


var moneyGeneratorCount := 0
var moonstoneGeneratorCount := 0
var moneyStorageCount := 0
var moonstoneStorageCount := 0

var maxMoonetenStorage := 0
var maxMoonstoneStorage := 0

# building ids
const rocket:int = 0
const shop:int = 1
const moonetenGenerator:int = 2
const moonstoneGenerator:int = 3
const moonetenStorage:int = 4
const moonstoneStorage:int = 5

const building_type:int = 0
const name_index:int = 1
const level_index:int = 2
const upgrade_cost_index:int = 3
const image_index:int = 4
const game_path_index:int = 5
const ressource_amount:int = 6
const max_storage_size:int = 7

# Constans for shopelements
const MOONETEN_GENERATOR_CARD = 0
const MOONSTONE_GENERATOR_CARD = 1
const MOONETEN_STORAGE_CARD = 2
const MOONSTONE_STORAGE_CARD = 3

# Constans for priceupdates
const UPGRADE_PRICE_1 = 2000
const UPGRADE_PRICE_2 = 10000
const UPGRADE_PRICE_3 = 50000
const UPGRADE_PRICE_4 = 75000

var generators_upgrade_costs:Array = [1000,2500,5000,7500]
var storage_upgrade_costs:Array = [3000,9000,15000,25000]
var generators_max_storage_size:Array = [1000,2000,3000,4000,5000]
var storage_max_storage_size:Array = [5000,10000,15000,20000,25000]


# Shopdata as a Dictionary
var shop_data: Array = [
	{'building_id':moonetenGenerator, 'name': "Moonetengenerator", 'price': 200, 'is_bought': false},
	{'building_id':moonstoneGenerator, 'name': "Moonstonegenerator", 'price': 200, 'is_bought': false},
	{'building_id':moonetenStorage, 'name': "Moonetenstorage", 'price': 1000, 'is_bought': false},
	{'building_id':moonstoneStorage, 'name': "Moonstonestorage", 'price': 1000, 'is_bought': false}
]
func update_upgrade_costs(current_costs:Array,new_costs:Array):
	for cost in new_costs:
		current_costs.append(cost)
		
	

func update_storage_size(current_size:Array,new_size:Array):
	for storage_size in new_size:
		current_size.append(storage_size)


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


func update_shop_data(shop_id, new_price):
	shop_data[shop_id]["price"] = new_price
	shop_data[shop_id]["is_bought"] = false
	savePlayerData()

#field id´s -2: building on the field; -1: no building on the field
var fieldArray := [[rocket,"Rocket",1,[100000,200000,400000],"","res://Minigame1/minigame_1.tscn", 0, [1000,2000,5000,10000]], [-1], [-1], [-1], [-1], [-1], [-1], [-1], [-1], [-1], [-1], [-1], [-1], [-2]]
var inventory:Array = []
func set_building(field_index:int,building:Array):
	fieldArray[field_index] = building
	saveFieldData()
	
func set_inventory(building_index:int,building_name:String,upgrade_costs:Array,image:String,game_path:String, building_ressource_amount:int, storage_size:Array):
	var building := []
	building.append(building_index)
	building.append(building_name)
	building.append(1)#building level
	building.append(upgrade_costs)
	building.append(image)
	building.append(game_path)
	building.append(building_ressource_amount)
	building.append(storage_size)
	inventory.append(building)
func edit_building(building_id:int,attribute_id:int, value):
	fieldArray[building_id][attribute_id] = value
	saveFieldData()
# data storage location
var ressourceBarDataString := "user://playerData.dat"
var fieldDataString := "user://fieldData.dat"

#declare timer variable
var timer

var last_player_position: Vector2 = Vector2(168,131)

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 60
	timer.timeout.connect(_on_timeout_timer)
	timer.start()
	loadPlayerData()
	loadFieldData()
	setMaxRessources()

# Function called when the timer times out
func _on_timeout_timer():
	var newMooneten := 10
	var ressourceAmount := 0
	if (getMooneten() + newMooneten) <= maxMoonetenStorage:
		addMooneten(newMooneten)
	else :
		setMooneten(maxMoonetenStorage)
	for n in range(0,14):
		if fieldArray[n][building_type] == moonetenGenerator || fieldArray[n][building_type] == moonstoneGenerator:
			newMooneten = fieldArray[n][level_index] * newMooneten
			if fieldArray[n][ressource_amount] <= fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1] - newMooneten:
				ressourceAmount = fieldArray[n][ressource_amount] + newMooneten
			else:
				ressourceAmount = fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1]
			edit_building(n, ressource_amount, ressourceAmount)
			newMooneten = 10
	timer.start()
	
# Setter function for mooneten variable
func setMooneten(value):
	mooneten = value
	savePlayerData()
	
# Getter function for mooneten variable
func getMooneten():
	return mooneten
	
# Function to add mooneten to the player's resources	
func addMooneten(value):
	mooneten = mooneten + value
	savePlayerData()
	
# Function to remove mooneten from the player's resources
func removeMooneten(value):
	mooneten = mooneten - value
	savePlayerData()

# Setter function for unixLastTime variable
func setUnixLastTime(value):
	unixLastTime = value
	savePlayerData()
	
# Getter function for unixLastTime variable	
func getUnixLastTime():
	return unixLastTime


# Setter function for energy variable
func setMoonstone(value):
	moonstone = value
	savePlayerData()

# Getter function for energy variable
func getMoonstone():
	return moonstone
	
# Function to add energy to the player's resources	
func addMoonstone(value):
	moonstone = moonstone + value
	savePlayerData()
	
# Function to remove energy from the player's resources
func removeMoonstone(value):
	moonstone = moonstone - value
	savePlayerData()
	
	
# Setter function for minigame_one_score variable
func setM1Score(value):
	minigame_one_score = value
	if minigame_one_score >= minigame_one_highscore:
		minigame_one_highscore = minigame_one_score
		savePlayerData()

func setMinigame2_highscore(value):
	if value > minigame2_highscore:
		minigame2_highscore = value
		savePlayerData()
		
func getMinigame2_highscore():
	return minigame2_highscore
# Getter function for minigame_one_score variable
func getM1Score():
	return minigame_one_score	

func setMinigame2_score(value):
	minigame2_score = value
	savePlayerData()
	
func getMinigame2_score():
	return minigame2_score
# Getter function for minigame_one_highscore variable
func getM1HighScore():
	return minigame_one_highscore

func isPlayingFirstTime():
	return firstGame
	
func setFirstGame(value):
	firstGame = value
	savePlayerData()
	
func get_last_player_position():
	return last_player_position

func set_last_player_position(value):
	last_player_position = value
	savePlayerData()


# Function to save player data to a file
func savePlayerData():
	var file = FileAccess.open(ressourceBarDataString, FileAccess.WRITE)
	file.store_var(firstGame)
	file.store_var(mooneten)
	file.store_var(moonstone)
	file.store_var(unixLastTime)
	file.store_var(minigame2_highscore)
	file.store_var(minigame_one_highscore)
	file.store_var(moneyGeneratorCount)
	file.store_var(moonstoneGeneratorCount)
	file.store_var(moneyStorageCount)
	file.store_var(moonstoneStorageCount)
	file.store_var(last_player_position)
	file.store_var(shop_data)
	file.store_var(inventory)
	file.store_var(generators_upgrade_costs)
	file.store_var(storage_upgrade_costs)
	file.store_var(generators_max_storage_size) 
	file.store_var(storage_max_storage_size)
	

# Function to load player data from a file	
func loadPlayerData():
	if FileAccess.file_exists(ressourceBarDataString):
		var file = FileAccess.open(ressourceBarDataString, FileAccess.READ)
		firstGame = file.get_var()
		mooneten = file.get_var()
		moonstone = file.get_var()
		unixLastTime = file.get_var()
		minigame2_highscore = file.get_var()
		minigame_one_highscore = file.get_var()
		moneyGeneratorCount = file.get_var()
		moonstoneGeneratorCount = file.get_var()
		moneyStorageCount = file.get_var()
		moonstoneStorageCount = file.get_var()
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
		
func saveFieldData():
	var file = FileAccess.open(fieldDataString, FileAccess.WRITE)
	for n in range(0,14):
		file.store_var(fieldArray[n])

# Function to load player data from a file	
func loadFieldData():
	if FileAccess.file_exists(fieldDataString):
		var file = FileAccess.open(fieldDataString, FileAccess.READ)
		for n in range(0,14):
			fieldArray[n] = file.get_var()
		addOfflineMooneten()
	else:
		saveFieldData()
# Function to add offline mooneten based on time elapsed since the last logout
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
		if fieldArray[n][building_type] == moonetenGenerator || fieldArray[n][building_type] == moonstoneGenerator:
			offlineMooneten = fieldArray[n][level_index] * offlineMooneten
			if offlineMooneten <= 1000:
				if fieldArray[n][ressource_amount] <= fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1] - offlineMooneten:
					ressourceAmount = fieldArray[n][ressource_amount] + offlineMooneten
				else:
					ressourceAmount = fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1]
			else:
				offlineMooneten = 1000
				if fieldArray[n][ressource_amount] <= fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1] - offlineMooneten:
					ressourceAmount = fieldArray[n][ressource_amount] + offlineMooneten
				else:
					ressourceAmount = fieldArray[n][max_storage_size][fieldArray[n][level_index] - 1]
			#print("Building: " + str(n) + " - Added: " + str(offlineMooneten) + " - RessourceAmount: " + str(ressourceAmount))
			edit_building(n, ressource_amount, ressourceAmount)
			offlineMooneten = diff * 5
	
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

func resetStats():
	firstGame = true
	mooneten = 0
	moonstone = 0
	unixLastTime = Time.get_unix_time_from_system()
	minigame2_highscore = 0
	minigame_one_highscore = 0
	moneyGeneratorCount = 3
	moonstoneGeneratorCount = 3
	moneyStorageCount = 3
	moonstoneStorageCount = 3
	fieldArray = [[rocket,"Rocket",1,[100000,200000,400000],"","res://Minigame1/minigame_1.tscn", 0, [1000,2000,5000,10000]], [-1], [-1], [-1], [-1], [-1], [-1], [-1], [-1], [-1], [-1], [-1], [-1], [-2]]
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
	
