extends Control


@onready var moonetenLabel = $MoonetenLabel
@onready var progressBarMoney = $ProgressBarMoney

@onready var energyLabel = $EnergyLabel
@onready var progressBarEnergy = $ProgressBarMoonstone

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	updateRessourceBar()



func updateRessourceBar():
	moonetenLabel.text = str(DataScript.getMooneten()) + " / " + str(DataScript.maxMoonetenStorage)
	progressBarMoney.value = DataScript.getMooneten()
	progressBarMoney.max_value = DataScript.maxMoonetenStorage
	energyLabel.text = str(DataScript.getMoonstone()) + " / " + str(DataScript.maxMoonstoneStorage)
	progressBarEnergy.value = DataScript.getMoonstone()
	progressBarEnergy.max_value = DataScript.maxMoonstoneStorage
