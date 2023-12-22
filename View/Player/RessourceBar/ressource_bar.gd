extends Control


@onready var moonetenLabel = $MoonetenLabel
@onready var progressBarMoney = $ProgressBarMoney

@onready var energyLabel = $EnergyLabel
@onready var progressBarEnergy = $ProgressBarMoonstone

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateRessourceBar()



func updateRessourceBar():
	moonetenLabel.text = str(DataScript.getMooneten())
	progressBarMoney.value = DataScript.getMooneten()
	energyLabel.text = str(DataScript.getMoonstone())
	progressBarEnergy.value = DataScript.getMoonstone()
