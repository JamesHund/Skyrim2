extends CanvasLayer

var active_screen

func _ready():
	$ReloadingText.hide()
func _process(delta): #handles input
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
			
func _change_active_screen(var screen):
	if active_screen != screen:
		if active_screen != null:
			active_screen.hide()
		active_screen = screen
		active_screen.show()
	else:
		active_screen.hide()
		active_screen = null
	
func _show_PlayerInfo():
	$PlayerInfo.show()
	
func _hide_PlayerInfo():
	$PlayerInfo.hide()
	
func _show_MainMenu():
	$MainMenu.show()
	
func _hide_MainMenu():
	$MainMenu.hide()
	
func _show_MerchantScreen(var NPC):
	$MerchantScreen._update_merchant(NPC)
	if active_screen != null:
		active_screen.hide()
	active_screen = $MerchantScreen	
	active_screen.show()
	

func _disable():
	set_process(false)
	if active_screen != null:
			active_screen.hide()
			active_screen=null
	
func _enable():
	set_process(true)
	
func _on_PauseMenu_resume():
	active_screen.hide()
	active_screen = null
	
func _on_MainMenu_new_game():
	Global.main_scene._new_game()
	_hide_MainMenu()
	
func _show_reload():
	print("on")
	$ReloadingText.show()
	
func _hide_reload():
	print("off")
	$ReloadingText.hide()
