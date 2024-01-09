extends Control


@onready var moonetenLabel = $Bars/MoonetenLabel
@onready var progressBarMoney = $Bars/ProgressBarMoney

@onready var energyLabel = $Bars/EnergyLabel
@onready var progressBarEnergy = $Bars/ProgressBarMoonstone

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	updateRessourceBar()



func updateRessourceBar():
	moonetenLabel.text = str(DataScript.getMooneten())
	progressBarMoney.value = DataScript.getMooneten()
	energyLabel.text = str(DataScript.getMoonstone())
	progressBarEnergy.value = DataScript.getMoonstone()
