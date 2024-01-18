extends Control

@onready var moonetenLabel: Node = $Bars/MoonetenLabel
@onready var progressBarMoney: Node = $Bars/ProgressBarMoney

@onready var energyLabel: Node = $Bars/EnergyLabel
@onready var progressBarEnergy: Node = $Bars/ProgressBarMoonstone

@onready var moonstone_label = $Bars/MoonstoneLabel
@onready var processbar_moonstone = $Bars/ProgressBarMoonstone


# Function: _process
# Description: Called every frame. 'delta' is the elapsed time since the previous frame.
# This function updates the resource bar.
func _process(_delta):
	updateRessourceBar()


# Function: updateResourceBar
# Description: Updates the resource bar display with current mooneten and moonstone values.
func updateRessourceBar():
	moonetenLabel.text = str(DataScript.get_mooneten()) + " / " + str(DataScript.maxMoonetenStorage)
	progressBarMoney.value = DataScript.get_mooneten()
	progressBarMoney.max_value = DataScript.maxMoonetenStorage
	moonstone_label.text = str(DataScript.getMoonstone()) + " / " + str(DataScript.maxMoonstoneStorage)
	processbar_moonstone.value = DataScript.getMoonstone()
	processbar_moonstone.max_value = DataScript.maxMoonstoneStorage
