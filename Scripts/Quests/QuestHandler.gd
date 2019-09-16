extends Node

var quest_gui
var quests = []
var active_quests = []

func _ready():
	var file = File.new()
	file.open("res://data/quest_data.json", File.READ)
	var result = JSON.parse(file.get_as_text())
	file.close()
	if result.error != OK:
		printerr("error parsing quest_data.json")
		return
	else:
		print("quest_data has been parsed correctly")
	var quest_arr = result.get_result().get("Quests")
	for quest in quest_arr:
		quests.append(Quest.new(quest.get("id"),quest.get("NPC"),quest.get("location_name"),quest.get("location_direction"),quest.get("quest_item"),quest.get("reward"),quest.get("difficulty"),0))

func _activate_quest(var id): #makes a quest active if there is a free quest slot, returns true if slot is free
	if active_quests.size() <= 3:
		quests[id].quest_state = 1
		active_quests.append(quests[id])
		return true
	return false
	
func _quest_item_collected(var item):
	quests[item.quest_id].quest_state = 2
	
func _complete_quest(var id):
	Global.main_scene._spawn_world_item_id(quests[id].reward, 1, Global.main_scene._get_Player_position())
	quests[id].quest_state = 3
	active_quests.erase(quests[id])
	
func _set_quest_gui(var ref):
	quest_gui = ref
	_update_quest_gui()
	
func _update_quest_gui():
	pass