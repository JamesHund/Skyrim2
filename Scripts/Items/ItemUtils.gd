extends Object

class_name ItemUtils, "res://Scripts/Items/ItemUtils.gd"
enum {TYPE_ARMOUR,TYPE_WEAPON,TYPE_MONEY,TYPE_HEALTH,TYPE_QUEST}

func _ready():
	pass

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

static func _get_item_sprite_rect(var id): #returns region of spritesheet occupied by item with id
	var row = floor(id/6)*32
	var column = int(id)%6*32
	return Rect2(column,row,32,32)