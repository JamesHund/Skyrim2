extends Node

func _save():
	#converting items from inventory to array for storage
	var inv = Global.main_scene.get_node("Inventory")
	var ids = [] #array of ids of each item
	for x in range(0,6): 
		ids.append([])
		ids[x].resize(4)
		for y in range(0,4):
			if inv.grid[x][y] != null:
				ids[x][y] = inv.grid[x][y].id
	var stacks = []
	for x in range(0,6): #array of stack sizes of each item
		stacks.append([])
		stacks[x].resize(4)
		for y in range(0,4):
			if inv.grid[x][y] != null:
				stacks[x][y] = inv.grid[x][y].stack_size
	var quests = [] #empty array to fill up with active quests
	for x in QuestHandler.quests:
		quests.append(x.quest_state)
	var file = File.new()
	if file.open("res://data/persistent/save.json", File.WRITE) != 0:
		print("Error opening save file for writing")
		return
	var all_data = {"ids" : ids,"stacks" : stacks, "quests" : quests}
	file.store_line(JSON.print(all_data))
	file.close()
	
func _load_from_save():
	var inv = Global.main_scene.get_node("Inventory")
	var file = File.new()
	file.open("res://data/persistent/save.json", File.READ)
	var content = file.get_as_text()
	file.close()
	var result = JSON.parse(content)
	if result.error != OK:
		printerr("error parsing save.json")
		return
	var dict = result.get_result()
	var ids = dict.get("ids")
	var stack = dict.get("stacks")
	var quests = dict.get("quests")
	for x in range(0,6):
		for y in range(0,4):
			if ids[x][y] != null:
				inv.grid[x][y] = ItemUtils._create_item(ids[x][y],stack[x][y])
				inv._update_gui(Vector2(x,y))
	for x in range(0,5):
		if quests[x] == 1:
			QuestHandler._activate_quest(x)
		if quests[x] == 2:
			QuestHandler._quest_item_collected_by_quest_id(x)
		if quests[x] == 3:
			QuestHandler._set_quest_complete(x)