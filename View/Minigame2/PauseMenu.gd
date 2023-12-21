extends Control

var timer_seconds
var countdown 
var countdownLable

var is_paused: 
	set(value): 
		is_paused = value
		visible = is_paused
		
func _ready():
	countdown = get_parent().get_node("Countdown")
	countdownLable = get_parent().get_node("Countdown/CountdownLable")
	is_paused = false
	timer_seconds = 2

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused
		get_tree().paused = is_paused

func _on_resume_pressed():
	self.is_paused = false
	countdown.visible = true
	$PauseTimer.start() 

func _on_exit_pressed():
	self.is_paused = false
	get_tree().paused = is_paused
	var world = load("res://Welt/world.tscn").instantiate()
	get_tree().root.add_child(world)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = world

func _on_pause_timer_timeout():
	if timer_seconds > 0:
		countdownLable.text = str(timer_seconds)
		timer_seconds -= 1
	else:
		timer_seconds = 2
		countdownLable.text = str(3)
		countdown.visible = false
		$PauseTimer.stop()
		get_tree().paused = is_paused
