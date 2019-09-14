extends MarginContainer

func _ready():
	pass # Replace with function body.



func _on_QuestMenu_visibility_changed():
	if is_visible_in_tree():
		_update_slots()
		
func _update_slots():
	pass
	
func _set_selected_quest():
	pass