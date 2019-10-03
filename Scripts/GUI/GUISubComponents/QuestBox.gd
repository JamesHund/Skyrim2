extends NinePatchRect

var id = -1
signal pressed(id)

#sets box to display name of quest and assigns id a value of _id
func _set_id(var _id):
	id = _id
	if id != -1:
		$QuestName.set_text(QuestHandler.quests[id].location_name)
	
#emits signal "pressed" with id as a parameter
func _on_Button_pressed():
	emit_signal("pressed",id)
