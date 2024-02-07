## This script manages the display of resource bars, including mooneten, money progress bar, energy, and moonstone progress bar. It updates the resource bars based on the current values obtained from the DataScript.


extends Control

## Onready reference to the node representing the mooneten label.
@onready var moonetenLabel: Node = $Bars/MoonetenLabel

## Onready reference to the node representing the progress bar for money.
@onready var progressBarMoney: Node = $Bars/ProgressBarMoney

## Onready reference to the node representing the energy label.
@onready var energyLabel: Node = $Bars/EnergyLabel

## Onready reference to the node representing the progress bar for energy (moonstone).
@onready var progressBarEnergy: Node = $Bars/ProgressBarMoonstone

## Onready reference to the label displaying the moonstone value.
@onready var moonstone_label: Label = $Bars/EnergyLabel

## Onready reference to the progress bar for moonstone.
@onready var processbar_moonstone: ProgressBar = $Bars/ProgressBarMoonstone


# Function: _process
## Called every frame. 'delta' is the elapsed time since the previous frame.
## This function updates the resource bar.
func _process(_delta):
	updateRessourceBar()


# Function: updateResourceBar
## Updates the resource bar display with current mooneten and moonstone values.
func updateRessourceBar():
	moonetenLabel.text = str(DataScript.get_mooneten()) + " / " + str(DataScript.maxMoonetenStorage)
	progressBarMoney.value = DataScript.get_mooneten()
	progressBarMoney.max_value = DataScript.maxMoonetenStorage
	moonstone_label.text = (
		str(DataScript.get_moonstone()) + " / " + str(DataScript.maxMoonstoneStorage)
	)
	processbar_moonstone.value = DataScript.get_moonstone()
	processbar_moonstone.max_value = DataScript.maxMoonstoneStorage
