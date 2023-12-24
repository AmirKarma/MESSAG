extends StaticBody2D

signal _on_buybutton_bought(bIndex)

var item

# Called when the node enters the scene tree for the first time.
func _ready():
	$icon.play("shopPlay")
	item = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if self.visible == true:
		if item == 0:
			$icon.play("moonetenGenerator")
			$countLabel.text = str(DataScript.moneyGeneratorCount)
		elif item == 1:
			$icon.play("moonstoneGenerator")
			$countLabel.text = str(DataScript.moonstoneGeneratorCount)
		elif item == 2:
			$icon.play("moonetenStorage")
			$countLabel.text = str(DataScript.moneyStorageCount)
		elif item == 3:
			$icon.play("moonstoneStorage")
			$countLabel.text = str(DataScript.moonstoneStorageCount)

func _on_buttonleft_pressed():
	if item == 0:
		item = 3
	elif item == 1:
		item = 0
	elif item == 2:
		item = 1
	elif item == 3:
		item = 2


func _on_buttonright_pressed():
	if item == 0:
		item = 1
	elif item == 1:
		item = 2
	elif item == 2:
		item = 3
	elif item == 3:
		item = 0


func _on_buttonbuy_pressed():
	emit_signal("_on_buybutton_bought", item)
