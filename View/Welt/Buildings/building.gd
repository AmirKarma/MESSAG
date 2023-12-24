extends Node2D

var id := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	id = getFieldIndex(position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateBuildings()

func updateBuildings():
	for n in range(2,14):
		if id == n:
			if DataScript.fieldArray[n] == 0:
				self.visible = true
				$icon.play("moonetenGenerator")
			elif DataScript.fieldArray[n] == 1:
				self.visible = true
				$icon.play("moonstoneGenerator")
			elif DataScript.fieldArray[n] == 2:
				self.visible = true
				$icon.play("moonetenStorage")
			elif DataScript.fieldArray[n] == 3:
				self.visible = true
				$icon.play("moonstoneStorage")
			elif DataScript.fieldArray[n] == 4:
				self.visible = true
				$icon.play("shopPlay")
			else:
				self.visible = false

func getFieldIndex(value):
	if(value.x >= 16 && value.x <= 80):
		if(value.y >= 144 && value.y <= 176):
			return 0
	if(value.x >= 144 && value.x <= 208):
		if(value.y >= 48 && value.y <= 80):
			return 1
	if(value.x >= 528 && value.x <= 592):
		if(value.y >= 48 && value.y <= 80):
			return 2
	if(value.x >= 496 && value.x <= 560):
		if(value.y >= -144 && value.y <= -112):
			return 3    
	if(value.x >= 208 && value.x <= 272):
		if(value.y >= -144 && value.y <= -112):
			return 4
	if(value.x >= -144 && value.x <= -80):
		if(value.y >= -144 && value.y <= -112):
			return 5
	if(value.x >= -496 && value.x <= -432):
		if(value.y >= -80 && value.y <= -48):
			return 6
	if(value.x >= -304 && value.x <= -240):
		if(value.y >= 80 && value.y <= 112):
			return 7
	if(value.x >= -176 && value.x <= -112):
		if(value.y >= 240 && value.y <= 272):
			return 8
	if(value.x >= -368 && value.x <= -304):
		if(value.y >= 336 && value.y <= 368):
			return 9
	if(value.x >= 48 && value.x <= 112):
		if(value.y >= 368 && value.y <= 400):
			return 10
	if(value.x >= 336 && value.x <= 400):
		if(value.y >= 432 && value.y <= 464):
			return 11
	if(value.x >= 432 && value.x <= 496):
		if(value.y >= 240 && value.y <= 272):
			return 12
	if(value.x >= 880 && value.x <= 944):
		if(value.y >= 240 && value.y <= 272):
			return 13
	return -1
