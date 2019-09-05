extends CanvasLayer

var active_screen

func _ready():
	$ReloadingText.hide()
func _process(delta): #handles input
	if Input.is_action_just_pressed("ui_inventory"):
		if active_screen != $InventoryScreen:
			if active_screen != null:
				active_screen.hide()
			active_screen = $InventoryScreen
			active_screen.show()
		else:
			active_screen.hide()
			active_screen = null
	if Input.is_action_just_pressed("ui_cancel"):
		if active_screen != null:
			active_screen.hide()
			active_screen=null
		else:
			active_screen = $PauseMenu
			active_screen.show()
	if Input.is_action_just_pressed("ui_dev_tools"):
		if $DevTools.is_visible():
			$DevTools.hide()
		else:
			$DevTools.show()
			
func _show_PlayerInfo():
	$PlayerInfo.show()
	
func _hide_PlayerInfo():
	$PlayerInfo.hide()
	
func _show_MainMenu():
	$MainMenu.show()
	
func _hide_MainMenu():
	$MainMenu.hide()

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
