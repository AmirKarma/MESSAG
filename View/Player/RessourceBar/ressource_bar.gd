extends Control


@onready var moonetenLabel = $Bars/MoonetenLabel
@onready var progressBarMoney = $Bars/ProgressBarMoney

@onready var energyLabel = $Bars/EnergyLabel
@onready var progressBarEnergy = $Bars/ProgressBarMoonstone

# Function: _ready
# Description: This function is called when the node enters the scene tree for the first time.
func _ready():
	pass

# Function: _process
# Description: Called every frame. 'delta' is the elapsed time since the previous frame.
# This function updates the resource bar.
func _process(_delta):
	updateRessourceBar()


# Function: updateResourceBar
# Description: Updates the resource bar display with current mooneten and moonstone values.
func updateRessourceBar():
	moonetenLabel.text = str(DataScript.getMooneten()) + " / " + str(DataScript.maxMoonetenStorage)
	progressBarMoney.value = DataScript.getMooneten()
	progressBarMoney.max_value = DataScript.maxMoonetenStorage
	energyLabel.text = str(DataScript.getMoonstone()) + " / " + str(DataScript.maxMoonstoneStorage)
	progressBarEnergy.value = DataScript.getMoonstone()
	progressBarEnergy.max_value = DataScript.maxMoonstoneStorage
