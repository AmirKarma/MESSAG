extends Control

var singleton_instance = null

var mooneten = 0
var energy = 0

var ressourceBarDataString = "res://Player/RessourceBar/ressourceBarData.dat"

@onready var moonetenLabel = $MoonetenLabel
@onready var progressBarMoney = $ProgressBarMoney

@onready var energyLabel = $EnergyLabel
@onready var progressBarEnergy = $ProgressBarMoonstone

func _init():
		if singleton_instance == null:
			singleton_instance = self


# Called when the node enters the scene tree for the first time.
func _ready():
	loadData()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func setMooneten(value):
	mooneten = value
	saveData()

func getMooneten():
	return mooneten
	
func addMooneten(value):
	mooneten = mooneten + value
	saveData()

func removeMooneten(value):
	mooneten = mooneten - value
	saveData()



func setEnergy(value):
	energy = value
	saveData()
	
func getEnergy():
	return energy
	
func addEnergy(value):
	energy = energy + value
	saveData()

func removeEnergy(value):
	energy = energy - value
	saveData()



func saveData():
	var file = FileAccess.open(ressourceBarDataString, FileAccess.WRITE)
	file.store_var(mooneten)
	file.store_var(energy)
	updateRessourceBar()
	
func loadData():
	if FileAccess.file_exists(ressourceBarDataString):
		var file = FileAccess.open(ressourceBarDataString, FileAccess.READ)
		mooneten = file.get_var()
		energy = file.get_var()
		updateRessourceBar()
	

func updateRessourceBar():
	moonetenLabel.text = str(mooneten)
	progressBarMoney.value = mooneten
	energyLabel.text = str(energy)
	progressBarEnergy.value = energy

func _on_timer_timeout():
	addMooneten(50)
	$Timer.start()
