extends MarginContainer

signal resume
signal controls
signal help

func _ready():
	hide()


func _on_PauseMenu_visibility_changed():
	if is_visible_in_tree():
		get_tree().set_pause(true)
	else:
		get_tree().set_pause(false)
		


func _on_Button_pressed():
	get_tree().set_pause(false)
	emit_signal("resume")


func _on_Exit_pressed():
	get_tree().quit()


func _on_SaveButton_pressed():
	SaveHandler._save()


func _on_ControlsButton_pressed():
	emit_signal("controls")


func _on_HelpButton_pressed():
	emit_signal("help")
