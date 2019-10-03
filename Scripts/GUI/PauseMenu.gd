extends MarginContainer

signal resume
signal controls
signal help

#called on entering SceneTree and hides PauseMenu
func _ready():
	hide()

#called when visibility of PauseMenu is changed, pausing game if true
func _on_PauseMenu_visibility_changed():
	if is_visible_in_tree():
		get_tree().set_pause(true)
	else:
		get_tree().set_pause(false)

#resumes game and emits signal "resume"
func _on_Button_pressed():
	get_tree().set_pause(false)
	emit_signal("resume")

#exits application
func _on_Exit_pressed():
	get_tree().quit()

#saves the game
func _on_SaveButton_pressed():
	SaveHandler._save()

#emits signal "controls"
func _on_ControlsButton_pressed():
	emit_signal("controls")

#emits signal "help"
func _on_HelpButton_pressed():
	emit_signal("help")
