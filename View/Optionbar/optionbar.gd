extends Control

@onready var building_rect = $optionbar_rect/buildingRect 
@onready var building_name = $optionbar_rect/building_name
@onready var building_level = $optionbar_rect/building_level
@onready var play_button:Button = $optionbar_rect/buttons_rect/buttons/play_button
@onready var collect_button:Button = $optionbar_rect/buttons_rect/buttons/collect_button
@onready var cancel_button:Button = $optionbar_rect/buttons_rect/CenterContainer/VBoxContainer/HSplitContainer/cancel_button
@onready var confirm_button:Button = $optionbar_rect/buttons_rect/CenterContainer/VBoxContainer/HSplitContainer/confirm_button
@onready var upgrade_button:Button = $optionbar_rect/buttons_rect/buttons/upgrade_button
@onready var costs_lable:Label = $optionbar_rect/buttons_rect/CenterContainer/VBoxContainer/HBoxContainer/costs_lable
@onready var upgrade_warning:Panel = $optionbar_rect/buttons_rect/buttons/Upgrade_warning
@onready var mooneten_img:Sprite2D = $optionbar_rect/buttons_rect/CenterContainer/VBoxContainer/HBoxContainer/Mooneten
@onready var moonstone_img:Sprite2D = $optionbar_rect/buttons_rect/CenterContainer/VBoxContainer/HBoxContainer/Moonstone
@onready var player:CharacterBody2D = get_node("/root/World/Player")
var optionbar_rect_size:Vector2
var building_image_pos:Vector2
var game_scene:String
var building_id:int = 0
const building_type:int = 0
const name_index:int = 1
const level_index:int = 2
const upgrade_cost_index:int = 3
const image_index:int = 4
const game_path_index:int = 5
const ressource_amount:int = 6
const max_storage_size:int = 7
var need_moonstone:bool = false
var need_mooneten:bool = false

# Function: _ready
# Description: Initializes text labels and positions for the option bar and building image.
func _ready():
	costs_lable.text = "  " 
	building_level.text = "Level "
	optionbar_rect_size = self.get_node("optionbar_rect").size
	building_image_pos = building_rect.size/2
	building_rect.get_node("building_image").position = building_image_pos

# Function: _on_close_button_pressed
# Description: Handles the event when the close button is pressed.
# Hides the option bar, resets buttons, and resets the needed resource flags.
func _on_close_button_pressed():
	hide_optionbar()
	reset_buttons()
	need_moonstone = false
	need_mooneten = false
	
# Function: hide_optionbar
# Description: Hides the option bar, enables player processes, and makes HUD visible.
func hide_optionbar():
	DataScript.is_in_building_menu = false
	self.visible = false
	player.set_process(true)
	player.set_physics_process(true)
	player.get_node("Camera2D/HUD").visible = true

# Function: set_optionbar
# Description: Sets the option bar's position, updates UI elements based on the building ID.
# Handles visibility of buttons, plays scenes if applicable, and checks upgrade eligibility.
func set_optionbar(positon : Vector2,id:int):
	self.position = positon
	building_id = id
	building_name.text = DataScript.fieldArray[id][name_index]
	if DataScript.fieldArray[building_id][game_path_index] == "":
		play_button.visible = false
	else:
		play_button.visible = true
		game_scene = DataScript.fieldArray[building_id][game_path_index]
	if DataScript.fieldArray[building_id][building_type] == DataScript.moonetenGenerator || DataScript.fieldArray[building_id][building_type] == DataScript.moonstoneGenerator:
		collect_button.visible = true
	else:
		collect_button.visible = false
	if id != DataScript.rocket:
		set_building_image()
	else:
		set_rocket_image()
	is_upgradeable()
	set_building_texts()
	set_bars()
	
# Function: set_building_image
# Description: Sets the building image based on the animation index.
# Plays the animation for the building image and adjusts visibility of UI elements.
func set_building_image():
	building_rect.get_node("building_image").play(DataScript.fieldArray[building_id][image_index])
	$optionbar_rect/buildingRect/rocket_image.visible = false
	$optionbar_rect/buildingRect/building_image.visible = true

# Function: set_rocket_image
# Description: Sets the rocket image and adjusts visibility of UI elements.
func set_rocket_image():
	building_rect.get_node("rocket_image").texture = load("res://Welt/Rocket/Rakete.png")
	$optionbar_rect/buildingRect/rocket_image.visible = true
	$optionbar_rect/buildingRect/building_image.visible = false

# Function: is_upgradeable
# Description: Checks if the building is upgradeable based on certain conditions.
# Disables the upgrade button and displays a warning if conditions are not met.
func is_upgradeable():
	if is_max_level():
		disable_upgrade_button()
		$optionbar_rect/buttons_rect/buttons/Upgrade_warning/Label.text = "Rocket Level is too low!"
		upgrade_warning.visible = true
	elif building_id == DataScript.rocket and !is_rocket_upgradeable():
		disable_upgrade_button()
		$optionbar_rect/buttons_rect/buttons/Upgrade_warning/Label.text = "You need to buy all Buildings in the Shop to upgrade the Rocket!"
		upgrade_warning.visible = true
	else:
		upgrade_warning.visible = false

# Function: is_rocket_upgradeable
# Description: Checks if the rocket is upgradeable by verifying if all buildings in the shop are bought.
# Returns true if upgradeable, false otherwise.		
func is_rocket_upgradeable() -> bool:
	for data in DataScript.shop_data:
		if !data["is_bought"]:
			return false
	return true

# Function: disable_upgrade_button
# Description: Disables the upgrade button by setting its appearance to dim gray and disabling it.
func disable_upgrade_button():
	upgrade_button.modulate = Color.DIM_GRAY
	upgrade_button.disabled = true

# Function: _on_play_1_button_pressed
# Description: Handles the event when the play 1 button is pressed.
# Changes the scene to the specified game scene.
func _on_play_1_button_pressed():
	get_tree().change_scene_to_file(game_scene)

# Function: _on_upgrade_button_pressed
# Description: Handles the event when the upgrade button is pressed.
# Checks needed resources, upgrade eligibility, sets resource images, and adjusts button visibility.
func _on_upgrade_button_pressed():
	needed_ressource_check()
	upgrade_check()
	set_ressource_img()
	$optionbar_rect/buttons_rect/buttons.visible = false
	$optionbar_rect/buttons_rect/CenterContainer.visible = true

# Function: set_ressource_img
# Description: Sets the visibility of resource images based on the needed resource.
func set_ressource_img():
	if need_mooneten:
		mooneten_img.visible = true
		moonstone_img.visible = false
	elif need_moonstone:
		moonstone_img.visible = true
		mooneten_img.visible = false

# Function: upgrade_check
# Description: Checks whether there are enough resources for an upgrade.
# Updates the confirm button's appearance and state accordingly.
func upgrade_check():
	if (need_mooneten and is_not_enough_mooneten()) or need_moonstone and is_not_enough_moonstone():
		confirm_button.modulate = Color.DIM_GRAY
		confirm_button.disabled = true

# Function: is_not_enough_mooneten
# Description: Checks if there is not enough mooneten for an upgrade.
# Returns true if the condition is met, false otherwise.
func is_not_enough_mooneten():
	return DataScript.getMooneten() < DataScript.fieldArray[building_id][upgrade_cost_index][DataScript.fieldArray[building_id][level_index] - 1]

# Function: is_not_enough_moonstone
# Description: Checks if there is not enough moonstone for an upgrade.
# Returns true if the condition is met, false otherwise.
func is_not_enough_moonstone():
	return DataScript.getMoonstone() < DataScript.fieldArray[building_id][upgrade_cost_index][DataScript.fieldArray[building_id][level_index] - 1]

# Function: is_max_level
# Description: Checks if the building is at its maximum level.
# Returns true if the condition is met, false otherwise.
func is_max_level():
	return DataScript.fieldArray[building_id][level_index] == len(DataScript.fieldArray[building_id][upgrade_cost_index]) + 1

# Function: _on_cancel_button_pressed
# Description: Handles the event when the cancel button is pressed.
# Calls the reset_buttons function.
func _on_cancel_button_pressed():
	reset_buttons()

# Function: _on_confirm_button_pressed
# Description: Handles the event when the confirm button is pressed.
# Checks for needed resources, deducts the cost, upgrades the building, and updates UI elements.
func _on_confirm_button_pressed():
	if need_mooneten:
		DataScript.removeMooneten(DataScript.fieldArray[building_id][upgrade_cost_index][DataScript.fieldArray[building_id][level_index] - 1])
		DataScript.edit_building(building_id,level_index, DataScript.fieldArray[building_id][level_index] + 1)
	elif need_moonstone:
		DataScript.removeMoonstone(DataScript.fieldArray[building_id][upgrade_cost_index][DataScript.fieldArray[building_id][level_index] - 1])
		DataScript.edit_building(building_id,level_index, DataScript.fieldArray[building_id][level_index] + 1)
	rocket_upgrade()
	set_building_texts()
	set_bars()
	reset_buttons()
	is_upgradeable()
	DataScript.setMaxRessources()
	
# Function: rocket_upgrade
# Description: Upgrades the rocket if the building type matches the rocket type.
# Calls the on_rocket_level_upgrade function from the DataScript.
func rocket_upgrade():
	if building_id == DataScript.fieldArray[building_id][building_type]:
		DataScript.on_rocket_level_upgrade()

# Function: set_building_texts
# Description: Sets the text values for building upgrade information.
# Checks if the building is not at its maximum level before updating the upgrade cost label.
# Updates the building level label.
func set_building_texts():
	if !is_max_level():
		costs_lable.text = "  " + str(DataScript.fieldArray[building_id][upgrade_cost_index][DataScript.fieldArray[building_id][level_index] - 1])
	building_level.text = "Level " + str(DataScript.fieldArray[building_id][level_index])

# Function: set_bars
# Description: Sets the visibility and values of resource bars based on the type of building.
func set_bars():
	$optionbar_rect/RessorceRect/moonetenbar.visible = true
	$optionbar_rect/RessorceRect/Moonete.visible = true
	$optionbar_rect/RessorceRect/moonstonebar.visible = true
	$optionbar_rect/RessorceRect/Moonstone.visible = true
	if DataScript.fieldArray[building_id][building_type] == DataScript.rocket:
		$optionbar_rect/RessorceRect/moonetenbar/mooneten_label.text = str(DataScript.fieldArray[building_id][ressource_amount]) + " / " + str(DataScript.fieldArray[building_id][max_storage_size][DataScript.fieldArray[building_id][level_index] - 1])
		$optionbar_rect/RessorceRect/moonetenbar.value = DataScript.fieldArray[building_id][ressource_amount]
		$optionbar_rect/RessorceRect/moonetenbar.max_value = DataScript.fieldArray[building_id][max_storage_size][DataScript.fieldArray[building_id][level_index] - 1]
		$optionbar_rect/RessorceRect/moonstonebar/moonstone_label.text = str(DataScript.fieldArray[building_id][ressource_amount]) + " / " + str(DataScript.fieldArray[building_id][max_storage_size][DataScript.fieldArray[building_id][level_index] - 1])
		$optionbar_rect/RessorceRect/moonstonebar.value = DataScript.fieldArray[building_id][ressource_amount]
		$optionbar_rect/RessorceRect/moonstonebar.max_value = DataScript.fieldArray[building_id][max_storage_size][DataScript.fieldArray[building_id][level_index] - 1]
	if DataScript.fieldArray[building_id][building_type] == DataScript.moonetenGenerator || DataScript.fieldArray[building_id][building_type] == DataScript.moonetenStorage:
		$optionbar_rect/RessorceRect/moonstonebar.visible = false
		$optionbar_rect/RessorceRect/Moonstone.visible = false
		$optionbar_rect/RessorceRect/moonetenbar/mooneten_label.text = str(DataScript.fieldArray[building_id][ressource_amount]) + " / " + str(DataScript.fieldArray[building_id][max_storage_size][DataScript.fieldArray[building_id][level_index] - 1])
		$optionbar_rect/RessorceRect/moonetenbar.value = DataScript.fieldArray[building_id][ressource_amount]
		$optionbar_rect/RessorceRect/moonetenbar.max_value = DataScript.fieldArray[building_id][max_storage_size][DataScript.fieldArray[building_id][level_index] - 1]
	if DataScript.fieldArray[building_id][building_type] == DataScript.moonstoneGenerator || DataScript.fieldArray[building_id][building_type] == DataScript.moonstoneStorage:
		$optionbar_rect/RessorceRect/moonetenbar.visible = false
		$optionbar_rect/RessorceRect/Moonete.visible = false
		$optionbar_rect/RessorceRect/moonstonebar/moonstone_label.text = str(DataScript.fieldArray[building_id][ressource_amount]) + " / " + str(DataScript.fieldArray[building_id][max_storage_size][DataScript.fieldArray[building_id][level_index] - 1])
		$optionbar_rect/RessorceRect/moonstonebar.value = DataScript.fieldArray[building_id][ressource_amount]
		$optionbar_rect/RessorceRect/moonstonebar.max_value = DataScript.fieldArray[building_id][max_storage_size][DataScript.fieldArray[building_id][level_index] - 1]

# Function: reset_buttons
# Description: Resets the appearance and functionality of buttons in the option bar.
func reset_buttons():
	$optionbar_rect/buttons_rect/buttons.visible = true
	$optionbar_rect/buttons_rect/CenterContainer.visible = false
	confirm_button.modulate = Color.WHITE
	confirm_button.disabled = false
	upgrade_button.modulate = Color.WHITE
	upgrade_button.disabled = false

# Function: needed_ressource_check
# Description: Checks the type of building and sets flags for needed resources accordingly.
func needed_ressource_check():
	print(DataScript.fieldArray[building_id][building_type])
	match(DataScript.fieldArray[building_id][building_type]):
		DataScript.moonetenGenerator, DataScript.moonetenStorage:
			need_moonstone = true
		DataScript.moonstoneGenerator, DataScript.moonstoneStorage, DataScript.rocket:
			need_mooneten = true


# Function: _on_collect_button_pressed
# Description: Handles the event when the collect button is pressed for a specific building.
# Checks the building type and updates resource amounts accordingly.
func _on_collect_button_pressed():
	if DataScript.fieldArray[building_id][building_type] == DataScript.moonetenGenerator:
		if DataScript.fieldArray[building_id][ressource_amount] > 0:
			if (DataScript.getMooneten() + DataScript.fieldArray[building_id][ressource_amount]) > DataScript.maxMoonetenStorage: 
				var temp : int = DataScript.getMooneten()
				DataScript.addMooneten(DataScript.maxMoonetenStorage - DataScript.getMooneten())
				DataScript.edit_building(building_id, ressource_amount, DataScript.fieldArray[building_id][ressource_amount] - (DataScript.maxMoonetenStorage - temp))
				set_bars()
			else:
				DataScript.addMooneten(DataScript.fieldArray[building_id][ressource_amount])
				DataScript.edit_building(building_id, ressource_amount, 0)
				set_bars()
	elif DataScript.fieldArray[building_id][building_type] == DataScript.moonstoneGenerator:
		if DataScript.fieldArray[building_id][ressource_amount] > 0:
			DataScript.addMoonstone(DataScript.fieldArray[building_id][ressource_amount])
			DataScript.edit_building(building_id, ressource_amount, 0)
			set_bars()
			if (DataScript.getMoonstone() + DataScript.fieldArray[building_id][ressource_amount]) > DataScript.maxMoonstoneStorage:
				var temp : int = DataScript.getMoonstone()
				DataScript.addMoonstone(DataScript.maxMoonstoneStorage - DataScript.getMoonstone())
				DataScript.edit_building(building_id, ressource_amount, DataScript.fieldArray[building_id][ressource_amount] - (DataScript.maxMoonstoneStorage - temp))
				set_bars()
			else:
				DataScript.addMoonstone(DataScript.fieldArray[building_id][ressource_amount])
				DataScript.edit_building(building_id, ressource_amount, 0)
				set_bars()
