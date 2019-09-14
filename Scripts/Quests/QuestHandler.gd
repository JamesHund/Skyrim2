extends Node

var quest_gui
var quests
var active_quests = []

func _ready():
	pass # Replace with function body.

func _activate_quest(var id): #makes a quest active if there is a free quest slot, returns true if slot is free
	if active_quests.size() <= 3:
		quests[id].quest_state = 1
		active_quests.append(quests[id])
		return true
	return false
	
func _quest_item_collected(var item):
	quests[item.quest_id].quest_state = 2
	
func _complete_quest(var id):
	quests[id].quest_state = 3
	active_quests.erase(quests[id])
	
func _set_quest_gui(var ref):
	quest_gui = ref
	_update_quest_gui()
	
func _update_quest_gui():
	pass