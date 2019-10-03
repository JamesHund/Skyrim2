extends CanvasLayer

var active_screen

#runs when GUI enters SceneTree and hides several GUI components
func _ready():
	$ReloadingText.hide()
	$HealingText.hide()
	$ControlsScreen.hide()
	$HelpScreen.hide()

#handles input that open and close GUI screens
func _process(delta): 
	if Input.is_action_just_pressed("ui_inventory"):
		_change_active_screen($InventoryScreen)
	if Input.is_action_just_pressed("ui_cancel"):
		if active_screen != null:
			active_screen.hide()
			active_screen=null
		else:
			active_screen = $PauseMenu
			active_screen.show()
	if Input.is_action_just_pressed("ui_quest_menu"):
		_change_active_screen($QuestMenu)
	if Input.is_action_just_pressed("ui_dev_tools"):
		if $DevTools.is_visible():
			$DevTools.hide()
		else:
			$DevTools.show()

#hides active screen and sets active_screen to screen showing it
func _change_active_screen(var screen):
	if active_screen != screen:
		if active_screen != null:
			active_screen.hide()
		active_screen = screen
		active_screen.show()
	else:
		active_screen.hide()
		active_screen = null

#shows PlayerInfo GUI
func _show_PlayerInfo():
	$PlayerInfo.show()
#hides PlayerInfo GUI
func _hide_PlayerInfo():
	$PlayerInfo.hide()

#shows MainMenu
func _show_MainMenu():
	$MainMenu.show()

#hides MainMenu
func _hide_MainMenu():
	$MainMenu.hide()

#changes active screen to ControlsScreen
func _show_ControlsScreen():
	_change_active_screen($ControlsScreen)

#changes active screen to HelpScreen
func _show_HelpScreen():
	_change_active_screen($HelpScreen)

#changes active screen to MerchantScreen and updates merchant to NPC in MerchantScreen
func _show_MerchantScreen(var NPC):
	$MerchantScreen._update_merchant(NPC)
	if active_screen != null:
		active_screen.hide()
	active_screen = $MerchantScreen	
	active_screen.show()
	
#sets active screen to QuestDialogue and calls sets quest in QuestDialogue using id of NPC
func _show_QuestDialogue(var NPC):
	$QuestDialogue._set_quest(NPC.id)
	if active_screen != null:
		active_screen.hide()
	active_screen = $QuestDialogue
	active_screen.show()
	
#disables input that is handled by GUIcontroller
func _disable():
	set_process(false)
	if active_screen != null:
			active_screen.hide()
			active_screen=null

#enables input that is handled by GUIcontroller
func _enable():
	set_process(true)

#called on PauseMenu resume, hiding active screen
func _on_PauseMenu_resume():
	active_screen.hide()
	active_screen = null

#called on MainMenu New Game, starts new Game and hides MainMenu
func _on_MainMenu_new_game():
	Global.main_scene._new_game()
	_hide_MainMenu()

#called on MainMenu Continue, continues game and hides MainMenu
func _on_MainMenu_continue_game():
	Global.main_scene._continue_game()
	_hide_MainMenu()

#shows ReloadingText
func _show_reload():
	$ReloadingText.show()

#hides ReloadingText
func _hide_reload():
	$ReloadingText.hide()

#shows HealingText for duration of timer
func _show_healing(var timer):
	$HealingText.show()
	yield(timer, "timeout")
	$HealingText.hide()

#shows controls screen
func _on_PauseMenu_controls():
	_show_ControlsScreen()
	
#shows help screen
func _on_PauseMenu_help():
	_show_HelpScreen()

#shows controls screen
func _on_MainMenu_controls():
	_show_ControlsScreen()
	
#shows help screen
func _on_MainMenu_help():
	_show_HelpScreen()
