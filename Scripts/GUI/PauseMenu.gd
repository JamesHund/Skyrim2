extends MarginContainer

signal resume

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
