extends NinePatchRect

var id = -1
signal pressed(id)

func _set_id(var _id):
	id = _id
	if id != -1:
		$QuestName.set_text(QuestHandler.quests[id].location_name)
	

func _on_Button_pressed():
	emit_signal("pressed",id)
