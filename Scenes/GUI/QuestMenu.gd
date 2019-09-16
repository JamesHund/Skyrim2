extends MarginContainer

onready var questboxes = get_node("Contents/Seperator/SubContainer/QuestSelection").get_children()

func _ready():
	hide()

func _on_QuestMenu_visibility_changed():
	if is_visible_in_tree():
		_update_slots()
		
func _update_slots():
	var i = 0
	for quest in QuestHandler.active_quests:
		questboxes[i].get_node("QuestName").set_text(quest.location_name)
		i+=1
	
func _set_selected_quest():
	pass

func _on_QuestBox_pressed(id):
	pass # Replace with function body.
