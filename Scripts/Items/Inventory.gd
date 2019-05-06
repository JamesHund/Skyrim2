extends Node
enum {TYPE_ARMOUR,TYPE_WEAPON,TYPE_MONEY,TYPE_HEALTH,TYPE_QUEST}
onready var grid = []
#onready var item_data = ItemData.new().items #returns an array of all the items available in game
var selected #Vector2 that indicates which item is currently being displayed
onready var inventory_screen = get_parent().get_node("GUI/InventoryScreen")

signal dropitem(item)

func _ready():
	for x in range(0,6): #max area 128*128, can change
		grid.append([])
		grid[x].resize(4)
	_create_and_add_item(6,1)
	

func _set_selected(var grid_pos):
	selected = grid_pos
	var item = grid[grid_pos.x][grid_pos.y]
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
		info += "\nFire-rate: "  + str(item.fire_rate) + "RPM\n"
		info += "Accuracy: Within " + str(item.spread) + " degrees\n"
		info += "Ammo capacity: " + str(item.base_capacity)
	elif item.type == TYPE_MONEY:
		type = "Money"
		info = "Can be used to pay for items from merchants"
	elif item.type == TYPE_HEALTH:
		type = "Healing"
		info = "Health-points: " + str(item.hp) + "\nHeal-time: " + str(item.heal_time)
	else:
		type = "Quest Item"
		info = "This item has been retrieved from a quest. Return it to its owner to complete the quest"
	inventory_screen._set_item_info(item.item_name,type,info)

func _clear_selected():
	selected = null
	inventory_screen._set_item_info("","","")

func _add_item(var item):
	if item == null:
		return false
	if item.type == TYPE_MONEY:
		if grid[5][3] == null:
			grid[5][3] = item
		elif !_stack(item, grid[5][3]):
			return false
		_update_gui(Vector2(5,3))
		return true
	else:
		for y in range(0,4):
			for x in range(0,5):
				if grid[x][y] == null:
					grid[x][y] = item
					_update_gui(Vector2(x,y))
					return true
				elif grid[x][y].id == item.id:
					if _stack(item,grid[x][y]):
						_update_gui(Vector2(x,y))
						return true
					else:
						_update_gui(Vector2(x,y))
						
		return false
	
func _create_and_add_item(var id, var stack_size):
	_add_item(ItemUtils._create_item(id,stack_size))
	
func _drop_selected():
	if selected == null:
		return
	var item = grid[selected.x][selected.y]
	emit_signal("dropitem",item)
	grid[selected.x][selected.y] = null
	_update_gui(selected)
	_clear_selected()
	
func _remove_item(var grid_pos): #input a Vector2
	grid[grid_pos.x][grid_pos.y] = null
	_update_gui(grid_pos)
	
func _move_item(var source_slot, var dest_slot): #takes vector2s

	
	if dest_slot.x ==5:
		if (dest_slot.y == 0 || dest_slot.y == 1):
			if grid[source_slot.x][source_slot.y].type != TYPE_WEAPON:
				return
		elif dest_slot.y == 2:
			if grid[source_slot.x][source_slot.y].type != TYPE_ARMOUR:
				return
		elif grid[source_slot.x][source_slot.y].type != TYPE_MONEY:
			return
	elif source_slot.x == 5:
		if grid[dest_slot.x][dest_slot.y] != null:
			if (source_slot.y == 0 || source_slot.y == 1):
				if grid[dest_slot.x][dest_slot.y].type != TYPE_WEAPON:
					return
			elif source_slot.y == 2:
				if grid[dest_slot.x][dest_slot.y].type != TYPE_ARMOUR:
					return
			elif grid[dest_slot.x][dest_slot.y].type != TYPE_MONEY:
				return

	if source_slot != dest_slot:
		var sx = source_slot.x
		var sy = source_slot.y
		var dx = dest_slot.x
		var dy = dest_slot.y
		if grid[dx][dy] == null:
			grid[dx][dy] = grid[sx][sy]
			grid[sx][sy] = null
		if grid[sx][sy] == null:
			_update_gui(source_slot)
		elif grid[dx][dy].id != grid[sx][sy].id:
			var temp_item = grid[dx][dy]
			grid[dx][dy] = grid[sx][sy]
			grid[sx][sy] = temp_item
		else:
			_stack(grid[sx][sy],grid[dx][dy])
		if source_slot.x == 5 || dest_slot.x == 5:
			_update_player_gear()
		
		_update_gui(source_slot)
		_update_gui(dest_slot)
	
func _stack(var source, var dest): #takes Item instances
	if dest.stack_size < dest.max_stack_size:
		var max_add = dest.max_stack_size - dest.stack_size
		if source.stack_size <= max_add:
			dest.stack_size+=source.stack_size
			source.queue_free() 
			return true #returns true if both items combine to a single stack
		else:
			dest.stack_size = dest.max_stack_size
			source.stack_size -= max_add
	return false #returns false if they couldn't combine to a single stack

func _update_gui(var slot): #takes in a Vector2 grid position
	if grid[slot.x][slot.y] != null:
		inventory_screen._change_sprite(slot, grid[slot.x][slot.y].id, grid[slot.x][slot.y].stack_size)
	else:
		inventory_screen._change_sprite(slot, -1, 1)
		
		
func _update_player_gear():
	pass
func _add_world_item(var worlditem):
	if _add_item(worlditem.item):
		worlditem.hide()
		worlditem.queue_free()
	
func _print_grid(): #prints inventory to console, for debugging inventory
	for y in range(0,4):
		for x in range(0,6):
			if grid[x][y] != null:
				printraw(grid[x][y].id)
				printraw(" ")
			else:
				printraw("null")
				printraw(" ")
		print("")
