extends Node
enum {TYPE_ARMOUR,TYPE_WEAPON,TYPE_MONEY,TYPE_HEALTH,TYPE_QUEST}
onready var grid = []
#onready var item_data = ItemData.new().items #returns an array of all the items available in game
var selected #Vector2 that indicates which item is currently being displayed
onready var inventory_screen = Global.main_scene.get_node("GUI/InventoryScreen")

signal dropitem(item)

func _ready():
	for x in range(0,6): 
		grid.append([])
		grid[x].resize(4)

func _set_selected(var grid_pos):
	selected = grid_pos
	var item = grid[grid_pos.x][grid_pos.y]
	var info = ItemUtils._get_item_info_string(item)
	inventory_screen._set_item_info(item.item_name,info[0],info[1])

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
	if item.type != TYPE_QUEST:
		emit_signal("dropitem",item)
		grid[selected.x][selected.y] = null
		_update_gui(selected)
		_clear_selected()

func _find_item(var id): #returns the first position of the item with that id as a Vector2()
	for y in range(0,4):
		for x in range(0,6):
			if grid[x][y] != null:
				if grid[x][y].id == id:
					return Vector2(x,y)
	
func _consume_item(var grid_pos): #input a Vector2
	if grid[grid_pos.x][grid_pos.y] != null:
		grid[grid_pos.x][grid_pos.y].stack_size -=1
		if grid[grid_pos.x][grid_pos.y].stack_size == 0:
			grid[grid_pos.x][grid_pos.y] = null
		_update_gui(grid_pos)
		return true
	else:
		return false
		
func _find_and_consume_item(var id):
	return _consume_item(_find_item(id))
	
func _move_item(var source_slot, var dest_slot): #takes vector2s, returns true if move was successful
	#checking gear slots to see if items are compatible
	if dest_slot.x ==5:
		if (dest_slot.y == 0 || dest_slot.y == 1):
			if grid[source_slot.x][source_slot.y].type != TYPE_WEAPON:
				return false
		elif dest_slot.y == 2:
			if grid[source_slot.x][source_slot.y].type != TYPE_ARMOUR:
				return false
		elif grid[source_slot.x][source_slot.y].type != TYPE_MONEY:
			return false
	elif source_slot.x == 5:
		if grid[dest_slot.x][dest_slot.y] != null:
			if (source_slot.y == 0 || source_slot.y == 1):
				if grid[dest_slot.x][dest_slot.y].type != TYPE_WEAPON:
					return false
			elif source_slot.y == 2:
				if grid[dest_slot.x][dest_slot.y].type != TYPE_ARMOUR:
					return false
			elif grid[dest_slot.x][dest_slot.y].type != TYPE_MONEY:
				return false

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
		return true
	
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
	var player_ref = Global.main_scene._get_player()
	if player_ref != null:
		if grid[5][0] != null:
			player_ref._set_weapon(grid[5][0].id,0)
		else:
			player_ref._set_weapon(-1,0)
		if grid[5][1] != null:
			player_ref._set_weapon(grid[5][1].id,1)
		else:
			player_ref._set_weapon(-1,1)
		if grid[5][2] != null:
			player_ref._set_armour(grid[5][2].id)
		else:
			player_ref._set_armour(-1)
			
func _use_money(var amount): #subtracts money from balance, if balance is sufficient returns true
	if grid[5][3] != null:
		if amount >= grid[5][3].stack_size:
			grid[5][3].stacksize -= amount
			if grid[5][3].stacksize == 0:
				grid[5][3].queue_free()
			_update_gui(Vector2(5,3))
			return true
		else:
			return false
	else:
		return false

func _gain_money(var amount):
	if grid[5][3] != null:
		grid[5][3].stack_size += amount
		_update_gui(Vector2(5,3))
	else:
		_create_and_add_item(26,amount)
			
func _sell_selected():
	if selected != null && grid[selected.x][selected.y] != null:
		_gain_money(ItemData.item_costs[grid[selected.x][selected.y].id])
		_consume_item(selected)
		_update_gui(selected)
		if grid[selected.x][selected.y] == null:
			_clear_selected()

func _buy(var id): #takes in an item id adds it to the inventory and subtracts money if there is enough
	print("buy in inv")
	var amount = ItemData.item_costs[id]
	print(amount)
	print(grid[5][3].stack_size)
	if grid[5][3] != null:
		if amount <= grid[5][3].stack_size:
			grid[5][3].stack_size -= amount
			if grid[5][3].stack_size == 0:
				grid[5][3].queue_free()
			_create_and_add_item(id, 1)
			_update_gui(Vector2(5,3))

func _add_world_item(var worlditem):
	if _add_item(worlditem.item):
		if worlditem.item.type == TYPE_QUEST:
			QuestHandler._quest_item_collected(worlditem.item)
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

