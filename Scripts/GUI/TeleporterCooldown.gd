extends Control

var total_time
onready var bar = $VBoxContainer/CenterContainer/VBoxContainer2/CenterContainer/TextureProgress

func _ready():
	hide()

func _show_cooldown(var timer):
	#if timer.get_time_left()>0:
	total_time = timer.get_wait_time()
	$IntervalTimer.start()
	show()
	$VisibleTimer.set_wait_time(timer.get_time_left())
	$VisibleTimer.start()
	bar.set_value($VisibleTimer.get_time_left()/total_time*100)
	#print("countdown" +

func _hide_cooldown():
	hide()

func _on_VisibleTimer_timeout():
	$IntervalTimer.stop()
	hide()


func _on_IntervalTimer_timeout():
	bar.set_value(bar.get_value() - $IntervalTimer.get_wait_time()/total_time*100)
