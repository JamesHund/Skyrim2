extends Node

var quests = []
var active_quests = []

#runs when entering SceneTree, parses quests from quest_data.json and populates 'quests'
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

#makes a quest of id active if there is a free quest slot, returns true if slot is free
func _activate_quest(var id): 
	if active_quests.size() <= 3:
		quests[id].quest_state = 1
		active_quests.append(quests[id])
		return true
	return false

#sets quest with quest_item equal to id of item
func _quest_item_collected(var item):
	quests[item.quest_id].quest_state = 2
	_check_if_active(item.quest_id)

#same as above method but takes in id of item as a parameter
func _quest_item_collected_by_quest_id(var id):
	quests[id].quest_state = 2
	_check_if_active(quests[id])

# this method sets quest state of quest with id to complete and spawns reward at player position
func _complete_quest(var id): 
	Global.main_scene.get_node("Inventory")._find_and_consume_item(quests[id].quest_item)
	Global.main_scene._spawn_world_item_id(quests[id].reward, 1, Global.main_scene._get_Player_position())
	_set_quest_complete(id)
	active_quests.erase(quests[id])

#sets quest of id to complete
func _set_quest_complete(var id):
	quests[id].quest_state = 3

#returns true if quest_item of quest with id has been collected
func _item_is_collected(var id): 
	if quests[id].quest_state >= 2:
		return true
	return false

#checks if quest with id is still active to restore active quests after saving
func _check_if_active(var id): 
	if (active_quests.find(quests[id]) == -1):
		active_quests.append(quests[id])
	