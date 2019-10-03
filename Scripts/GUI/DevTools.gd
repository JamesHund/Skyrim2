extends MarginContainer

#class for debugging GUI

signal godmode(mode)
signal printgrid

func _ready():
	hide()


func _on_GodMode_toggled(button_pressed):
	if button_pressed:
		print("god_mode on")
		emit_signal("godmode",true)
	else:
		print("god mode off")
		emit_signal("godmode",false)

func _on_PrintGrid_pressed():
	emit_signal("printgrid")
