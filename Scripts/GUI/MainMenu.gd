extends MarginContainer

signal new_game
signal continue_game
signal controls
signal help

#called on entering SceneTree, hides main menu
func _ready():
	hide()

#emits signal new_game
func _on_NewGameButton_pressed():
	emit_signal("new_game")

#emits signal continue_game
func _on_ContinueButton_pressed():
	emit_signal("continue_game")
	
#emits signal controls
func _on_ControlsButton_pressed():
	emit_signal("controls")
	
#emits signal help
func _on_HelpButton_pressed():
	emit_signal("help")

#exits application
func _on_ExitButton_pressed():
	get_tree().quit()
