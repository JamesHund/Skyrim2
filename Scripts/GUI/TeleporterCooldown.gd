extends Control

var total_time
onready var bar = $VBoxContainer/CenterContainer/VBoxContainer2/CenterContainer/TextureProgress

#called on entering SceneTree, hides TeleporterCooldown
func _ready():
	hide()

#shows cooldown for the duration of the timer
func _show_cooldown(var timer):
	total_time = timer.get_wait_time()
	$IntervalTimer.start()
	show()
	$VisibleTimer.set_wait_time(timer.get_time_left())
	$VisibleTimer.start()
	bar.set_value($VisibleTimer.get_time_left()/total_time*100)

#hides TeleporterCooldown
func _hide_cooldown():
	hide()

#stops interval timer
func _on_VisibleTimer_timeout():
	$IntervalTimer.stop()
	hide()

#updates the value of the bar to reflect time remaining
func _on_IntervalTimer_timeout():
	bar.set_value(bar.get_value() - $IntervalTimer.get_wait_time()/total_time*100)
