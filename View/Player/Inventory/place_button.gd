extends Button


@onready var player:CharacterBody2D = get_node("/root/World/Player")

func _on_pressed():
	print(self.name)
	player.place_building(int(str(self.name)))
