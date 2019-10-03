extends Node
enum {TYPE_ARMOUR,TYPE_WEAPON,TYPE_MONEY,TYPE_HEALTH,TYPE_QUEST}
onready var grid = []
#onready var item_data = ItemData.new().items #returns an array of all the items available in game
var selected #Vector2 that indicates which item is currently being displayed
onready var inventory_screen = Global.main_scene.get_node("GUI/InventoryScreen")

signal dropitem(item)

#Called when Inventory is instanced and initializes grid to an empy array
func _ready():
	for x in range(0,6): 
		grid.append([])
		grid[x].resize(4)

#This method takes in a Vector2 and sets the selected item to the item in that position.
#It updates the Inventory Screen to display information about the selected item.
func _set_selected(var grid_pos):
	selected = grid_pos
	var item = grid[grid_pos.x][grid_pos.y]
	var info = ItemUtils._get_item_info_string(item)
	inventory_screen._set_item_info(item.item_name,info[0],info[1])

#Clears the selected item and the information displayed in the Inventory Screen
func _clear_selected():
	selected = null
	inventory_screen._set_item_info("","","")

#Takes in an item instance and attempts to add it to the inventory returning true if succesful
#and false if unsuccessful. It also updates the Invnetory Screen if the succesful.
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
	
#Creates and adds an item of id and stacksize to inventory
func _create_and_add_item(var id, var stack_size):
	_add_item(ItemUtils._create_item(id,stack_size))
	
#Emits dropitem signal passing item as a parameter, removing the item and updating the GUI
func _drop_selected():
	if selected == null:
		return
	var item = grid[selected.x][selected.y]
	if item.type != TYPE_QUEST:
		emit_signal("dropitem",item)
		grid[selected.x][selected.y] = null
		_update_gui(selected)
		_clear_selected()

#Returns the first position of the item with that id as a Vector2
#If item with that id is not found returns null
func _find_item(var id): 
	for y in range(0,4):
		for x in range(0,6):
			if grid[x][y] != null:
				if grid[x][y].id == id:
					return Vector2(x,y)
	return null

#Subtracts 1 from the stacksize of item at grid_pos if item exists
#Returns true is the operation was successful and updates InventoryScreen
#Otherwise returning false
func _consume_item(var grid_pos): #input a Vector2
	if grid_pos != null:
		grid[grid_pos.x][grid_pos.y].stack_size -=1
		if grid[grid_pos.x][grid_pos.y].stack_size == 0:
			grid[grid_pos.x][grid_pos.y] = null
		_update_gui(grid_pos)
		return true
	else:
		return false
		
#Attempts to find item with id and consume it returning true if it was succesful and false if not
func _find_and_consume_item(var id):
	return _consume_item(_find_item(id))

#When the player attempts to move an item in the inventory this method is run
#Takes in source and destination slots, returns true if move was successful
func _move_item(var source_slot, var dest_slot): 
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

#Attempts to stack source item into dest item
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

#Updates GUI slot at Vector2 position slot in InventoryScreen
func _update_gui(var slot): 
	if grid[slot.x][slot.y] != null:
		inventory_screen._change_sprite(slot, grid[slot.x][slot.y].id, grid[slot.x][slot.y].stack_size)
	else:
		inventory_screen._change_sprite(slot, -1, 1)
		
#Updates weapons[] and armour in Player object from gear slots
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
			
#subtracts amount (int) from balance, if balance is sufficient returns true
func _use_money(var amount): 
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

#Adds amount of money to inventory 
func _gain_money(var amount):
	if grid[5][3] != null:
		grid[5][3].stack_size += amount
		_update_gui(Vector2(5,3))
	else:
		_create_and_add_item(26,amount)

#Sells selected item, checking item_costs array and adding money to inventory
func _sell_selected():
	if selected != null && grid[selected.x][selected.y] != null:
		_gain_money(ItemData.item_costs[grid[selected.x][selected.y].id])
		_consume_item(selected)
		_update_gui(selected)
		if grid[selected.x][selected.y] == null:
			_clear_selected()

#takes in an item id adds it to the inventory and subtracts money if there is enough
func _buy(var id):
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

#Attemps to add world item to inventory and delete from world if there is space in inventory
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

