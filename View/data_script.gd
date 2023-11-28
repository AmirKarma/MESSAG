extends Control

var mooneten = 0
var energy = 0
var unixLastTime = 0

var ressourceBarDataString = "res://Player/playerData.dat"

var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 60
	timer.timeout.connect(_on_timeout_timer)
	timer.start()
	loadData()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timeout_timer():
	addMooneten(50)
	timer.start()

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


func setUnixLastTime(value):
	unixLastTime = value
	saveData()
	
func getUnixLastTime():
	return unixLastTime



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
	file.store_var(unixLastTime)
	
func loadData():
	if FileAccess.file_exists(ressourceBarDataString):
		var file = FileAccess.open(ressourceBarDataString, FileAccess.READ)
		mooneten = file.get_var()
		energy = file.get_var()
		unixLastTime = file.get_var()
		addOfflineMooneten()
	else:
		unixLastTime = Time.get_unix_time_from_system()
		saveData()
	

func addOfflineMooneten():
	var diff = Time.get_unix_time_from_system() - getUnixLastTime()
	diff = diff / 60
	diff = round(diff)
	var offlineMooneten = diff * 50
	if offlineMooneten > 1000:
		offlineMooneten = 1000
	addMooneten(offlineMooneten)
	
