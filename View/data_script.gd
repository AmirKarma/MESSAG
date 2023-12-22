# This script extends the Node2D class
# This script handles behavior and interactions for a 2D node in the game.
extends Control 


# Player resources and game data variables
var firstGame = false
var mooneten = 0 
var energy = 0
var unixLastTime = 0 #logout time
var minigame_one_highscore = 0
var minigame_one_score = 0

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


var moneyGeneratorCount = 0
var moonstoneGeneratorCount = 0
var shopCount = 0
var moneyStorageCount = 0
var moonstoneStorageCount = 0

var moneyGeneratorActiveCount = 0
var moonstoneGeneratorActiveCount = 0
var moneyStorageActiveCount = 0
var moonstoneStorageActiveCount = 0

#field id´s -2: building on the field; -1: no building on the field
var fieldZero = -2
var fieldOne = -2
var fieldTwo = -1
var fieldThree = -1
var fieldFour = -1
var fieldFive = -1
var fieldSix = -1
var fieldSeven = -1
var fieldEight = -1
var fieldNine = -1
var fieldTen = -1
var fieldEleven = -1
var fieldTwelve = -1
var fieldThirteen = -2

# data storage location
var ressourceBarDataString = "res://Player/playerData.dat"
var fieldDataString = "res://Welt/fieldData.dat"

#declare timer variable
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 60
	timer.timeout.connect(_on_timeout_timer)
	timer.start()
	loadPlayerData()
	loadFieldData()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# Function called when the timer times out
func _on_timeout_timer():
	var newMooneten = 50
	if moneyGeneratorActiveCount > 0:
		newMooneten = newMooneten + (moneyGeneratorActiveCount * newMooneten)
	addMooneten(newMooneten)
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
func setEnergy(value):
	energy = value
	savePlayerData()

# Getter function for energy variable
func getEnergy():
	return energy
	
# Function to add energy to the player's resources	
func addEnergy(value):
	energy = energy + value
	savePlayerData()
	
# Function to remove energy from the player's resources
func removeEnergy(value):
	energy = energy - value
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

# Function to save player data to a file
func savePlayerData():
	var file = FileAccess.open(ressourceBarDataString, FileAccess.WRITE)
	file.store_var(firstGame)
	file.store_var(mooneten)
	file.store_var(energy)
	file.store_var(unixLastTime)
	file.store_var(minigame2_highscore)
	file.store_var(minigame_one_highscore)
	file.store_var(moneyGeneratorCount)
	file.store_var(moonstoneGeneratorCount)
	file.store_var(shopCount)
	file.store_var(moneyStorageCount)
	file.store_var(moonstoneStorageCount)
	file.store_var(moneyGeneratorActiveCount)
	file.store_var(moonstoneGeneratorActiveCount)
	file.store_var(moneyStorageActiveCount)
	file.store_var(moonstoneStorageActiveCount)
	

# Function to load player data from a file	
func loadPlayerData():
	if FileAccess.file_exists(ressourceBarDataString):
		var file = FileAccess.open(ressourceBarDataString, FileAccess.READ)
		firstGame = file.get_var()
		mooneten = file.get_var()
		energy = file.get_var()
		unixLastTime = file.get_var()
		minigame2_highscore = file.get_var()
		minigame_one_highscore = file.get_var()
		moneyGeneratorCount = file.get_var()
		moonstoneGeneratorCount = file.get_var()
		shopCount = file.get_var()
		moneyStorageCount = file.get_var()
		moonstoneStorageCount = file.get_var()
		moneyGeneratorActiveCount = file.get_var()
		moonstoneGeneratorActiveCount = file.get_var()
		moneyStorageActiveCount = file.get_var()
		moonstoneStorageActiveCount = file.get_var()
		addOfflineMooneten()
	else:
		firstGame = true
		unixLastTime = Time.get_unix_time_from_system()
		savePlayerData()
		
func saveFieldData():
	var file = FileAccess.open(fieldDataString, FileAccess.WRITE)
	file.store_var(fieldZero)
	file.store_var(fieldOne)
	file.store_var(fieldTwo)
	file.store_var(fieldThree)
	file.store_var(fieldFour)
	file.store_var(fieldFive)
	file.store_var(fieldSix)
	file.store_var(fieldSeven)
	file.store_var(fieldEight)
	file.store_var(fieldNine)
	file.store_var(fieldTen)
	file.store_var(fieldEleven)
	file.store_var(fieldTwelve)
	file.store_var(fieldThirteen)
	

# Function to load player data from a file	
func loadFieldData():
	if FileAccess.file_exists(fieldDataString):
		var file = FileAccess.open(fieldDataString, FileAccess.READ)
		fieldZero = file.get_var()
		fieldOne = file.get_var()
		fieldTwo = file.get_var()
		fieldThree = file.get_var()
		fieldFour = file.get_var()
		fieldFive = file.get_var()
		fieldSix = file.get_var()
		fieldSeven = file.get_var()
		fieldEight = file.get_var()
		fieldNine = file.get_var()
		fieldTen = file.get_var()
		fieldEleven = file.get_var()
		fieldTwelve = file.get_var()
		fieldThirteen = file.get_var()
	else:
		saveFieldData()
# Function to add offline mooneten based on time elapsed since the last logout
func addOfflineMooneten():
	var diff = Time.get_unix_time_from_system() - getUnixLastTime()
	diff = diff / 60
	diff = round(diff)
	var offlineMooneten = diff * 50
	if moneyGeneratorActiveCount > 0:
		offlineMooneten = offlineMooneten + (moneyGeneratorActiveCount * offlineMooneten)
	if offlineMooneten > 1000:
		offlineMooneten = 1000
	addMooneten(offlineMooneten)
	
func resetStats():
	firstGame = true
	mooneten = 0
	energy = 0
	unixLastTime = Time.get_unix_time_from_system()
	minigame2_highscore = 0
	minigame_one_highscore = 0
	moneyGeneratorCount = 0
	moonstoneGeneratorCount = 0
	shopCount = 0
	moneyStorageCount = 0
	moonstoneStorageCount = 0
	fieldZero = -2
	fieldOne = -2
	fieldTwo = -1
	fieldThree = -1
	fieldFour = -1
	fieldFive = -1
	fieldSix = -1
	fieldSeven = -1
	fieldEight = -1
	fieldNine = -1
	fieldTen = -1
	fieldEleven = -1
	fieldTwelve = -1
	fieldThirteen = -2
	moneyGeneratorActiveCount = 0
	moonstoneGeneratorActiveCount = 0
	moneyStorageActiveCount = 0
	moonstoneStorageActiveCount = 0
	savePlayerData()
	saveFieldData()
	
