extends MarginContainer

#if help screen is visible, pause game else unpause game
func _on_Control_visibility_changed():
	if is_visible_in_tree():
		get_tree().set_pause(true)
	else:
		get_tree().set_pause(false)
