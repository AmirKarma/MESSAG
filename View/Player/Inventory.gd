extends StaticBody2D

signal _on_buybutton_bought(bIndex)

var item

# Called when the node enters the scene tree for the first time.
func _ready():
	$icon.play("shopPlay")
	item = DataScript.moonetenGenerator


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if self.visible == true:
		if item == DataScript.moonetenGenerator:
			$icon.play("moonetenGenerator")
			$countLabel.text = str(DataScript.moneyGeneratorCount)
		elif item == DataScript.moonstoneGenerator:
			$icon.play("moonstoneGenerator")
			$countLabel.text = str(DataScript.moonstoneGeneratorCount)
		elif item == DataScript.moonetenStorage:
			$icon.play("moonetenStorage")
			$countLabel.text = str(DataScript.moneyStorageCount)
		elif item == DataScript.moonstoneStorage:
			$icon.play("moonstoneStorage")
			$countLabel.text = str(DataScript.moonstoneStorageCount)

func _on_buttonleft_pressed():
	if item == DataScript.moonetenGenerator:
		item = DataScript.moonstoneStorage
	elif item == DataScript.moonstoneGenerator:
		item = DataScript.moonetenGenerator
	elif item == DataScript.moonetenStorage:
		item = DataScript.moonstoneGenerator
	elif item == DataScript.moonstoneStorage:
		item = DataScript.moonetenStorage

func _on_buttonright_pressed():
	if item == DataScript.moonetenGenerator:
		item = DataScript.moonstoneGenerator
	elif item == DataScript.moonstoneGenerator:
		item = DataScript.moonetenStorage
	elif item == DataScript.moonetenStorage:
		item = DataScript.moonstoneStorage
	elif item == DataScript.moonstoneStorage:
		item = DataScript.moonetenGenerator


func _on_buttonbuy_pressed():
	emit_signal("_on_buybutton_bought", item)
