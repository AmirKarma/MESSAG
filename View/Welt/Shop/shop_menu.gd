extends Control

# Nodes for the scene
@onready var building_name: Label = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/ScrollContainer/HBoxContainer/Buiding_Card/VBoxContainer/Name
@onready var building_count:Label = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/ScrollContainer/HBoxContainer/Buiding_Card/VBoxContainer/Count
@onready var building_price:Label = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/ScrollContainer/HBoxContainer/Buiding_Card/VBoxContainer/HBoxContainer/Price
@onready var building_image:AnimatedSprite2D = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/ScrollContainer/HBoxContainer/Buiding_Card/VBoxContainer/HSplitContainer/building_image
@onready var price_hsplit:HSplitContainer = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/ScrollContainer/HBoxContainer/Buiding_Card/VBoxContainer/HBoxContainer/PriceHSplitContainer
@onready var building_card:NinePatchRect = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/ScrollContainer/HBoxContainer/Buiding_Card
@onready var mooneten_amount:Label = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/Panel/HBoxContainer/Panel/HBoxContainer/Mooneten_amount
@onready var moonstone_amount:Label = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/Panel/HBoxContainer/Panel2/HBoxContainer/Moonstone_amount
@onready var buttons:Control = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/ScrollContainer/HBoxContainer/Buiding_Card/VBoxContainer/button
@onready var buy_button:Button = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/ScrollContainer/HBoxContainer/Buiding_Card/VBoxContainer/button/buy_button
@onready var mooneten_img:Sprite2D = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/ScrollContainer/HBoxContainer/Buiding_Card/VBoxContainer/HBoxContainer/HSplitContainer2/Coin
@onready var moonstone_img:Sprite2D = $NinePatchRect/VBoxContainer/Panel/VBoxContainer/ScrollContainer/HBoxContainer/Buiding_Card/VBoxContainer/HBoxContainer/HSplitContainer2/Moonstone
@onready var player:CharacterBody2D = get_node("/root/World/Player")

# Variable for the current building type
const building_type:int = 0

# Variable that sets the need of the ressources
var need_moonstone:bool = false
var need_mooneten:bool = false

# Variable for the building button
var currentButton: Button = null

# Function: _ready
# Description: Initializes the shop when the scene is ready.
func _ready():
	set_shop()

# Function: set_shop
# Description: Sets up the shop by resetting it, populating it with building data, and updating resource amounts.
func set_shop():
	reset_shop()
	building_card.visible = true
	var building_data = DataScript.shop_data.duplicate(true)
	building_data.reverse()
	for data in building_data:
		set_building_data(data["building_id"],data["name"], str(data["price"]),data["is_bought"])
	
	
	mooneten_amount.text = str(DataScript.getMooneten())
	moonstone_amount.text = str(DataScript.getMoonstone())
	building_card.visible = false

# Function: reset_shop
# Description: Removes all child nodes from the building_card parent.
func reset_shop():
	var parent = building_card.get_parent()
	for child in range(len(parent.get_children()) - 1,1,-1):
		parent.remove_child(parent.get_child(child))

# Function: set_building_data
# Description: Sets up the building data in the shop. Sets the building name, button, price, count, image, needed resources,
# and adds a duplicate of the building card.
func set_building_data(building_id:int,buidling_name: String, price: String,is_bougth:bool):
	building_name.text = buidling_name
	set_building_button(buidling_name,is_bougth,int(price))
	set_building_price(price)
	set_building_count(building_id,is_bougth)
	set_building_image(building_id)
	needed_ressource_check(building_id)
	set_ressource_img()
	building_card.add_sibling(building_card.duplicate())
	need_mooneten  = false
	need_moonstone = false

# Function: set_ressource_img
# Description: Sets the visibility of Mooneten and Moonstone images based on the needs of the building.
func set_ressource_img():
	if need_mooneten:
		mooneten_img.visible = true
		moonstone_img.visible = false
	elif need_moonstone:
		moonstone_img.visible = true
		mooneten_img.visible = false

# Function: set_building_count
# Description: Sets the text for the building_count label based on the building_id and whether the building is bought.
func set_building_count(building_id:int,is_bougth:bool):
	var all_buildings:int = 0
	var bougth_buildings:int = 0
	for building in DataScript.fieldArray:
		if building[building_type] == building_id:
			bougth_buildings += 1
	for building in DataScript.inventory:
		if !building.is_empty():
			if building[building_type] == building_id:
				bougth_buildings += 1
	if !is_bougth:
		all_buildings = bougth_buildings +1
	else:
		all_buildings = bougth_buildings 
	building_count.text = str(bougth_buildings) + '/' + str(all_buildings)

# Function: set_building_price
# Description: Sets the price label for a building in the shop. Adjusts the label's text and custom_minimum_size based on the length of the price.
func set_building_price(price:String):
	building_price.text = price
	if len(price) < 7:
		price_hsplit.custom_minimum_size.x = 18 - (len(price) * 2) 
	else:
		price_hsplit.custom_minimum_size.x = 18 - (len(price) * 2) -2

# Function: set_building_image
# Description: Sets the image for a building in the shop based on its building_id.
func set_building_image(building_id:int):
	match(building_id):
		DataScript.moonetenGenerator:
				building_image.play("moonetenGenerator")
		DataScript.moonstoneGenerator:
				building_image.play("moonstoneGenerator")
		DataScript.moonetenStorage:
				building_image.play("moonetenStorage")
		DataScript.moonstoneStorage:
				building_image.play("moonstoneStorage")

# Function: set_building_button
# Description: Sets up a building button in the shop. Creates a duplicate of the buy_button, connects its pressed signal
# to the appropriate method, and adjusts visibility and state based on whether the building is bought and if it can be purchased.
func set_building_button(buidling_name: String,is_bought:bool,price:int):
	if currentButton != null:
		buttons.remove_child(currentButton)
		
	var button: Button = buy_button.duplicate()
	button.name = buidling_name + "_button"
	button.pressed.connect(Callable(self,"_on_"+button.name+"_pressed"),2)
	button.visible = true
	if is_bought:
		set_card_disabled(button)
	else:
		set_card_enabled()
	if !can_purchase(price):
		button.disabled = true
	buttons.add_child(button)

	currentButton = button

# Function: _on_Moonetengenerator_button_pressed
# Description: Called when the Mooneten Generator button is pressed. Checks if the player has enough Moonstone
# to purchase the Mooneten Generator. If so, adds the Mooneten Generator to the player's inventory, deducts
# the cost from the player's resources, sets the building as bought, and updates the shop.
func _on_Moonetengenerator_button_pressed():
	var building_data = DataScript.shop_data
	if DataScript.getMoonstone() >= building_data[DataScript.MOONETEN_GENERATOR_CARD]["price"]:
		DataScript.set_inventory(DataScript.moonetenGenerator,"Moonetengenerator",DataScript.generators_upgrade_costs,"moonetenGenerator","res://Minigame2/minigame2.tscn", 0, DataScript.generators_max_storage_size)
		set_moonstone(DataScript.MOONETEN_GENERATOR_CARD)
		set_is_bought(DataScript.MOONETEN_GENERATOR_CARD)
		set_shop()

# Function: _on_Moonetenstorage_button_pressed
# Description: Called when the Mooneten Storage button is pressed. Checks if the player has enough Moonstone
# to purchase the Mooneten Storage. If so, adds the Mooneten Storage to the player's inventory, deducts
# the cost from the player's resources, sets the building as bought, and updates the shop.
func _on_Moonetenstorage_button_pressed():
	var building_data = DataScript.shop_data
	if DataScript.getMoonstone() >= building_data[DataScript.MOONETEN_STORAGE_CARD]["price"]:
		DataScript.set_inventory(DataScript.moonetenStorage,"Moonetenstorage",DataScript.storage_upgrade_costs,"moonetenStorage","", 0, DataScript.storage_max_storage_size)
		set_moonstone(DataScript.MOONETEN_STORAGE_CARD)
		set_is_bought(DataScript.MOONETEN_STORAGE_CARD)
		set_shop()
	
# Function: _on_Moonstonegenerator_button_pressed
# Description: Called when the Moonstone Generator button is pressed. Checks if the player has enough Mooneten
# to purchase the Moonstone Generator. If so, adds the Moonstone Generator to the player's inventory, deducts
# the cost from the player's resources, sets the building as bought, and updates the shop.
func _on_Moonstonegenerator_button_pressed():
	var building_data = DataScript.shop_data
	if DataScript.getMooneten() >= building_data[DataScript.MOONSTONE_GENERATOR_CARD]["price"]:
		DataScript.set_inventory(DataScript.moonstoneGenerator,"Moonstonegenerator",DataScript.generators_upgrade_costs,"moonstoneGenerator","", 0, DataScript.generators_max_storage_size)
		set_mooneten(DataScript.MOONSTONE_GENERATOR_CARD)
		set_is_bought(DataScript.MOONSTONE_GENERATOR_CARD)
		set_shop()

# Function: _on_Moonstonestorage_button_pressed
# Description: Called when the Moonstone Storage button is pressed. Checks if the player has enough Mooneten
# to purchase the Moonstone Storage. If so, adds the Moonstone Storage to the player's inventory, deducts
# the cost from the player's resources, sets the building as bought, and updates the shop.
func _on_Moonstonestorage_button_pressed():
	var building_data = DataScript.shop_data
	if DataScript.getMooneten() >= building_data[DataScript.MOONSTONE_STORAGE_CARD]["price"]:
		DataScript.set_inventory(DataScript.moonstoneStorage,"Moonstonestorage",DataScript.storage_upgrade_costs,"moonstoneStorage","", 0, DataScript.storage_max_storage_size)
		set_mooneten(DataScript.MOONSTONE_STORAGE_CARD)
		set_is_bought(DataScript.MOONSTONE_STORAGE_CARD)
		set_shop()

# Function: set_is_bought
# Description: Sets the "is_bought" attribute of the building in the shop_data at the given card_index to true.
func set_is_bought(card_index:int):
	var building_data = DataScript.shop_data
	building_data[card_index]["is_bought"] = true

# Function: can_purchase
# Description: Checks if the player has enough Mooneten to purchase a building with the given price.
# Returns: True if the player can purchase, otherwise false.
func can_purchase(price) -> bool:
	return DataScript.getMooneten() >= price

# Function: set_mooneten
# Description: Removes the Mooneten cost of the building at the given card_index from the player's resources.
func set_mooneten(card_index:int):
	var building_data = DataScript.shop_data
	DataScript.removeMooneten(building_data[card_index]["price"])

# Function: set_moonstone
# Description: Removes the Moonstone cost of the building at the given card_index from the player's resources.
func set_moonstone(card_index:int):
	var building_data = DataScript.shop_data
	DataScript.removeMoonstone(building_data[card_index]["price"])

# Function: set_card_disabled
# Description: Disables the given button and sets the building card's modulation to DIM_GRAY.
func set_card_disabled(button:Button):
	button.disabled = true
	building_card.modulate = Color.DIM_GRAY

# Function: set_card_enabled
# Description: Sets the building card's modulation back to WHITE.
func set_card_enabled():
	building_card.modulate = Color.WHITE

# Function: _on_close_button_pressed
# Description: Called when the close button is pressed. Hides the building card, enables player processes, and makes HUD visible.
func _on_close_button_pressed():
	visible = false
	player.set_process(true)
	player.set_physics_process(true)
	player.get_node("Camera2D/HUD").visible = true

# Function: needed_ressource_check
# Description: Checks the building type and sets the appropriate resource requirements.
func needed_ressource_check(building_id:int):
	match(building_id):
		DataScript.moonetenGenerator, DataScript.moonetenStorage:
			need_moonstone = true
		DataScript.moonstoneGenerator, DataScript.moonstoneStorage, DataScript.rocket:
			need_mooneten = true
