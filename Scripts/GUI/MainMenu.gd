extends MarginContainer

signal new_game
signal continue_game
signal controls
signal help

func _ready():
	hide()

func _on_NewGameButton_pressed():
	emit_signal("new_game")
	

func _on_ContinueButton_pressed():
	emit_signal("continue_game")
	

func _on_ControlsButton_pressed():
	emit_signal("controls")
	

func _on_HelpButton_pressed():
	emit_signal("help")


func _on_ExitButton_pressed():
	get_tree().quit()
