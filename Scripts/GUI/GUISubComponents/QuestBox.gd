extends NinePatchRect

var id
signal pressed(id)

func _set_id(var _id):
	$QuestName.set_text(QuestHandler.quests[id].location_name)
	id = _id

func _on_Button_pressed():
	emit_signal("pressed",id)
