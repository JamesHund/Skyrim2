extends Node

class_name ItemData, "res://Scripts/Items/ItemData.gd"

#stores a dictionary of every item in the game, on initialization items.json is parsed into a set of items and appended to items[]
#ItemData is loaded as a singleton since there is only a single set of items
#items[] can therefore be accessed from anywhere in code without instancing a new ItemData object (only a single instance exists)
#loot_table is also parsed from a json file and is used to randomnly spawn loot
var items
var loot_table
var item_costs

	
func _init():
	print("began parsing of items")
	items = []
	var file = File.new()
	file.open("res://data/items.json", File.READ)
	var content = file.get_as_text()
	file.close()
	var result = JSON.parse(content)
	if result.error != OK:
		printerr("error parsing items.json")
		return 0
	var dict = result.get_result().get("Items")
	for item in dict.get("Armour"):
		items.append(Armour.new(item.get("id"),item.get("item_name"),item.get("protection")))
	for item in dict.get("Weapons"):
		var a = item.get("id")
		var b = item.get("item_name")
		var c = item.get("base_damage")
		var d = item.get("fire_mode")
		var e = item.get("fire_rate")
		var f = item.get("projectile_count")
		var g = item.get("spread")
		var h = item.get("projectile_speed")
		var i = item.get("base_capacity")
		items.append(Weapon.new(a, b, c,  d, e, f, g, h, i))
	for item in dict.get("TieredWeapons"):
		var original = items[item.get("base_id")]
		var a = item.get("id")
		var b
		var c
		var d = original.get("fire_mode")
		var e = original.get("fire_rate")
		var f = original.get("projectile_count")
		var g = original.get("spread")
		var h = original.get("projectile_speed")
		var i
		if item.get("tier") == 2:
			b = "Tier 2 " + original.get("item_name")
			c = ceil(original.get("base_damage")*1.3)
			i  = ceil(original.get("base_capacity")*1.15)
		else:
			b = "Tier 3 " + original.get("item_name")
			c = ceil(original.get("base_damage")*1.5)
			i  = ceil(original.get("base_capacity")*1.25)
		items.append(Weapon.new(a,b,c,d,e,f,g,h,i))
	for item in dict.get("Health"):
		items.append(Health.new(item.get("id"),item.get("item_name"),item.get("stack_size"),item.get("max_stack_size"),item.get("hp"),item.get("heal_time")))
	for item in dict.get("Quest"):
		items.append(QuestItem.new(item.get("id"),item.get("item_name"), item.get("quest_id")))
	var gold = dict.get("Money")
	items.append(Item.new(gold.get("id"),gold.get("item_name"),gold.get("type"),gold.get("stack_size"),gold.get("max_stack_size")))
	print("parsing of item data complete")
	#parsing second file:
	print("parsing of loot table begun")
	loot_table = []
	file = File.new()
	file.open("res://data/loot_table.json", File.READ)
	content = file.get_as_text()
	file.close()
	result = JSON.parse(content)
	if result.error != OK:
		printerr("error parsing loot_table.json")
		return 0
	loot_table = result.get_result().get("Loot")
	#parsing third file
	item_costs = []
	file = File.new()
	file.open("res://data/item_costs.json", File.READ)
	content = file.get_as_text()
	file.close()
	result = JSON.parse(content)
	if result.error != OK:
		printerr("error parsing item_costs.json")
		return 0
	item_costs = result.get_result().get("item_costs")
	
	


