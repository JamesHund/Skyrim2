extends Object

class_name ItemUtils, "res://Scripts/Items/ItemUtils.gd"
enum {TYPE_ARMOUR,TYPE_WEAPON,TYPE_MONEY,TYPE_HEALTH,TYPE_QUEST}

#Utility class which contains functions pertaining to items

#creates an item of id and stack_size and returns it
static func _create_item(var id, var stack_size): 
	var item_data = ItemData.items
	var item_ref = item_data[id] #reference to template item in item_data array
	var type = item_ref.type
	var item
	if type == TYPE_ARMOUR:
		item = Armour.new(item_ref.id,item_ref.item_name,item_ref.protection)
	elif type == TYPE_WEAPON:
		var a = item_ref.id
		var b = item_ref.item_name
		var c = item_ref.base_damage
		var d = item_ref.fire_mode
		var e = item_ref.fire_rate
		var f = item_ref.projectile_count
		var g = item_ref.spread
		var h = item_ref.projectile_speed
		var i = item_ref.base_capacity
		item = Weapon.new(a,b,c,d,e,f,g,h,i)
	elif type == TYPE_MONEY:
		item = Item.new(item_ref.id,item_ref.item_name, item_ref.type, stack_size, item_ref.max_stack_size)
	elif type == TYPE_HEALTH:
		item = Health.new(item_ref.id, item_ref.item_name, stack_size, item_ref.max_stack_size,item_ref.hp, item_ref.heal_time)
	else:
		item = QuestItem.new(item_ref.id,item_ref.item_name,item_ref.quest_id)
	return item

#returns a Rect2 which defines the region on of spritesheet occupied by item with id
static func _get_item_sprite_rect(var id):
	var row = floor(id/6)*32
	var column = int(id)%6*32
	return Rect2(column,row,32,32)

#returns name of item of id
static func _get_item_name(var id):
	return ItemData.items[id].item_name

#returns item type and item stats as strings (in an array with the two elements) taking an id as a parameter
static func _get_item_info_string_by_id(var id):
	return _get_item_info_string(ItemData.items[id])

#returns item type and item stats as strings (in an array with the two elements) taking item as a parameter
static func _get_item_info_string(var item):
	var type
	var info
	if item.type == TYPE_ARMOUR:
		type = "Armour"
		info = "Protection: " + str(item.protection) + " percent"
	elif item.type == TYPE_WEAPON:
		type = "Weapon"
		info = "Damage per bullet: " + str(item.base_damage) + "\nFire-mode: "
		if item.fire_mode:
			info += "Automatic"
		else:
			info += "Semi-Automatic"
		info += "\nFire-rate: "  + str(item.fire_rate) + "RPM\nAccuracy: Within " 
		info += str(item.spread) + " degrees\nAmmo capacity: " + str(item.base_capacity)
	elif item.type == TYPE_MONEY:
		type = "Money"
		info = "Can be used to pay for items from merchants"
	elif item.type == TYPE_HEALTH:
		type = "Healing"
		info = "Health-points: " + str(item.hp) + "\nHeal-time: " + str(item.heal_time)
	else:
		type = "Quest Item"
		info = "This item has been retrieved from a quest. Return it to its owner to complete the quest"
	return [type,info]