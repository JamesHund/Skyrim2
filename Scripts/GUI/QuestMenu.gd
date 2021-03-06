extends MarginContainer

onready var questboxes = get_node("Contents/Seperator/SubContainer/QuestSelection").get_children()
var difficulty = ["Very Easy","Easy","Normal","Hard","Very Hard"]

#method runs when entering SceneTree, hides QuestMenu
func _ready():
	hide()

#checks if QuestMenu is visible and will call '_update_slots()'
func _on_QuestMenu_visibility_changed():
	if is_visible_in_tree():
		_update_slots()

#scans through active quests and updates quest slots to correspond
func _update_slots():
	var i = 0
	for quest in QuestHandler.active_quests:
		questboxes[i]._set_id(quest.id)
		i+=1

#displays quest information of quest with id in the main panel
func _set_selected_quest(var id):
	print("quest id " + str(id))
	if id != -1:
		var quest = QuestHandler.quests[id]
		var text = ""
		text += "The " + NPCdata.npc_list[id].get("name") + " has tasked you with retrieving his stolen "
		text += ItemUtils._get_item_name(quest.quest_item) + ".\nHe was assaulted by goblins at the "
		text += quest.location_name + " which is located " + quest.location_direction + ".\n"
		text += "Return the " + ItemUtils._get_item_name(quest.quest_item) + " to the " + NPCdata.npc_list[id].get("name")
		text += " to receive a reward.\nThe difficulty of this quest is " + difficulty[quest.difficulty] + "."
		$Contents/Seperator/SubContainer/CenterContainer/NinePatchRect/Text.set_text(text)
		
#called when a slot is clicked and sets selected quest to id
func _on_QuestBox_pressed(id):
	print("qeustBOx pressed")
	_set_selected_quest(id)
